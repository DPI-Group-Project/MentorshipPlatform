class MatchesController < ApplicationController
  before_action :set_match, only: %i[show edit update destroy]

  # GET /matches or /matches.json
  def index
    @matches = Match.all
  end

  # GET /matches/1 or /matches/1.json
  def show; end

  # GET /matches/new
  def new
    @match = Match.new
  end

  # GET /matches/1/edit
  def edit; end

  def create
    cohort_id = current_user.cohort.id
    create_matches_for_cohort(cohort_id)

    flash[:notice] = "Matches created successfully."
    redirect_to matches_path
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = "Failed to create matches: #{e.message}"
    redirect_to matches_path
  end

  # Method triggered by the scheduler (Programmatically Triggered)
  def create_for_cohort(cohort)
    create_matches_for_cohort(cohort.id)
  end

  private

  def create_matches_for_cohort(cohort_id)
    sorted_shortlist = ShortList.where(cohort_id: cohort_id).order(:created_at, :ranking)
    Rails.logger.info "Starting match creation for cohort ##{cohort_id} at #{Time.current}"

    sorted_shortlist.each do |shortlist|
      mentor = User.find_by(id: shortlist.mentor_id)
      mentee = User.find_by(id: shortlist.mentee_id)
      cohort = Cohort.find(shortlist.cohort_id)
      # Log mentor, mentee, and cohort data
      Rails.logger.debug "Creating match: mentor=#{mentor.inspect}, mentee=#{mentee.inspect}, cohort=#{cohort.inspect}"

      # Skip if either mentor or mentee is not found
      next if mentor.nil? || mentee.nil?
      # Skip if a match already exists for this mentor/mentee pair in the same cohort
      next if Match.exists?(mentee_id: mentee.id, cohort_id: cohort.id)

      # Log cohort member and capacity
      cohort_member = CohortMember.find_by(email: mentor.email, cohort_id: cohort.id)
      if cohort_member.nil? || cohort_member.capacity.nil? || mentor.mentee_capacity_count(cohort.id) >= cohort_member.capacity
        Rails.logger.warn "Skipping match creation for cohort #{cohort.id}, mentor #{mentor.email} due to invalid cohort member, no capacity, or reached capacity."
        next
      end

      # Try to create the match and log any exceptions
      begin
        Match.create!(
          mentor_id: mentor.id,
          mentee_id: mentee.id,
          cohort_id: cohort.id,
          active: true
        )
        Rails.logger.info "Successfully created match: mentor=#{mentor.id}, mentee=#{mentee.id}, cohort=#{cohort.id}"
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error "Failed to create match: #{e.message}"
      end
    end

    Rails.logger.info "Finished match creation for cohort ##{cohort_id} at #{Time.current}"

    # TODO: might need to be a background job
    cohort = Cohort.find_by(id: cohort_id)
    cohort.send_matching_results_emails
  end

  # PATCH/PUT /matches/1 or /matches/1.json
  def update
    respond_to do |format|
      if @match.update(match_params)
        format.html { redirect_to match_url(@match), notice: "Match was successfully updated." }
        format.json { render :show, status: :ok, location: @match }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1 or /matches/1.json
  def destroy
    @match.destroy!

    respond_to do |format|
      format.html { redirect_to matches_url, notice: "Match was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_match
    @match = Match.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def match_params
    params.require(:match).permit(:mentor_id, :mentee_id, :cohort_id, :active)
  end
end
