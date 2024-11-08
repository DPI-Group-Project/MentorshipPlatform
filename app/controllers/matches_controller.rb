class MatchesController < ApplicationController
  before_action :set_match, only: %i[show edit update destroy]

  # GET /matches or /matches.json
  def index
    @matches = Match.all
  end

  # GET /matches/1 or /matches/1.json
  def show
  end

  # GET /matches/new
  def new
    @match = Match.new
  end

  # GET /matches/1/edit
  def edit
  end

  def create
    cohort_id = current_user.cohort.id  # TODO: get cohort_id from param
    sorted_shortlist = ShortList.where(cohort_id: cohort_id)
                                .order(:ranking, :created_at)

    sorted_shortlist.each do |shortlist|
      mentor = User.find(shortlist.mentor_id)
      mentee = User.find(shortlist.mentee_id)
      cohort = Cohort.find(shortlist.cohort_id)

      next if Match.exists?(mentee_id: mentee.id, cohort_id: cohort.id)
      cohort_member = CohortMember.find_by(email: mentor.email, cohort_id: cohort.id)
      next if cohort_member.nil? || cohort_member.capacity <= 0

      Match.create!(
        mentor_id: mentor.id,
        mentee_id: mentee.id,
        cohort_id: cohort.id,
        active: true
      )
      cohort_member.update!(capacity: cohort_member.capacity - 1)
    end

    flash[:notice] = "Matches created successfully."
    redirect_to matches_path

  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = "Failed to create matches: #{e.message}"
    redirect_to matches_path
  end

  # POST /matches or /matches.json
  # def create
  #   cohort_id = 1
  #   mentors = CohortMember.where(role: 'mentor', cohort_id: cohort_id).select(:email, :capacity)
  #
  #   mentors.each do |mentor|
  #     user = User.find_by(email: mentor.email)
  #     next unless user
  #
  #     shortlisted_mentees = ShortList.where(mentor_id: user.id)
  #                                    .order(:ranking, :created_at)
  #                                    .limit(mentor.capacity)
  #
  #     shortlisted_mentees.each do |shortlist|
  #       Match.create!(
  #         mentor_id: user.id,
  #         mentee_id: shortlist.mentee_id,
  #         cohort_id: shortlist.cohort_id,
  #         active: true
  #       )
  #     end
  #
  #     mentor.update(capacity: mentor.capacity - shortlisted_mentees.count)
  #   end

  #   flash[:notice] = "Matches created successfully."
  #   redirect_to matches_path
  # rescue ActiveRecord::RecordInvalid => e
  #   flash[:alert] = "Failed to create matches: #{e.message}"
  #   redirect_to matches_path
  # end

  # PATCH/PUT /matches/1 or /matches/1.json
  def update
    respond_to do |format|
      if @match.update(match_params)
        format.html { redirect_to match_url(@match), notice: 'Match was successfully updated.' }
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
      format.html { redirect_to matches_url, notice: 'Match was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_match
    @match = Match.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def match_params
    params.require(:match).permit(:mentor_id, :mentee_id, :cohort_id, :active)
  end
end