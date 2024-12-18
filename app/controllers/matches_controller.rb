class MatchesController < ApplicationController
  before_action :set_match, only: %i[update destroy]
  before_action :set_cohort, only: %i[index create update]

  def index
    @cohort = Cohort.find_by(id: @cohort_id)
    @matches = Match.where(cohort_id: @cohort_id)
    @available_mentors = User.mentors_with_capacity(@cohort.id)
    current_time = Time.current.utc
    @current_time_in_user_zone = current_time.strftime("%Y-%m-%d %H:%M:%S UTC")
    @match = Match.new
  end

  def new
    @match = Match.new
    @cohort = Cohort.find(params[:cohort_id])
  end

  def create
    @match = Match.new(match_params)

    if @match.save
      respond_to do |format|
        format.html { redirect_to matches_path(cohort_id: @cohort_id), notice: "Match created successfully!" }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to matches_path(cohort_id: @cohort_id), alert: "Match was not created, try again" }
        format.js
      end
    end
  end

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

  def set_match
    @match = Match.find(params[:id])
  end

  def set_cohort
    @cohort_id = params[:cohort_id]
  end

  def match_params
    params.require(:match).permit(:mentor_id, :mentee_id, :cohort_id, :active)
  end
end
