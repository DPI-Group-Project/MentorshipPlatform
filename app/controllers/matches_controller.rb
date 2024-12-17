class MatchesController < ApplicationController
  before_action :set_match, only: %i[show edit update destroy]
  before_action :set_cohort, only: %i[index create update]

  # GET /matches or /matches.json
  def index
    @cohort = Cohort.find_by(id: @cohort_id)
    @matches = Match.where(cohort_id: @cohort_id)
    @available_mentors = User.mentors_with_capacity(@cohort.id)
    current_time = Time.current.utc
    @current_time_in_user_zone = current_time.strftime("%Y-%m-%d %H:%M:%S UTC")
    @match = Match.new
  end

  # GET /matches/1 or /matches/1.json
  def show; end

  def new
    @match = Match.new
    @cohort = Cohort.find(params[:cohort_id])
  end

  # GET /matches/1/edit
  def edit; end

  def create
    @match = Match.new(match_params)

    if @match.save
      # Respond with JS (AJAX)
      respond_to do |format|
        format.html { redirect_to matches_path(cohort_id: @cohort_id), notice: "Match created successfully!" }
        format.js # This will call create.js.erb
      end
    else
      # If validation fails, respond with JS to show errors
      respond_to do |format|
        format.html { redirect_to matches_path(cohort_id: @cohort_id), alert: "Match was not created, try again" }
        format.js # This will trigger create.js.erb to handle errors
      end
    end
  end

  # def create
  #   create_matches_for_cohort(@cohort_id)

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
        format.html { redirect_to matches_path(cohort_id: @match.cohort_id), notice: "Match was successfully updated." }
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
      format.html { redirect_to matches_path(cohort_id: @match.cohort_id), notice: "Match was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def create_matches_for_cohort(cohort_id)
    cohort = Cohort.find(cohort_id)
    CohortMatchingService.new(cohort).call
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_match
    @match = Match.find(params[:id])
  end

  def set_cohort
    @cohort_id = params[:cohort_id]
  end

  # Only allow a list of trusted parameters through.
  def match_params
    params.require(:match).permit(:mentor_id, :mentee_id, :cohort_id, :active)
  end
end
