class CohortsController < ApplicationController
  before_action :set_cohort, only: %i[ update destroy ]

  def index
    @program = Program.find(current_user.program_admin.program_id)
    @cohorts = @program.cohorts
    @current_program = @program

    @sidebar_data = {
      program_name: @program.name,
      admin_name: current_user.first_name,
      cohorts: @program.cohorts,

    }
  end

  def show
    @admin_data = ProgramAdmin.find_by(user_id: current_user.id)
    @cohort = Cohort.find(params[:id])
    @program_admin = ProgramAdmin.new
    @current_program = Program.find(current_user.program_admin.program_id)
    @cohorts = Cohort.where(program_id: @current_program.id)
    @program_admins = ProgramAdmin.where(program_id: @current_program&.id)
    @total_matches = @cohorts.sum { |cohort| cohort.matches.count }
    @days_since_creation = (@current_program.created_at.to_date..Date.today).count
    @low_rated_surveys = Survey.includes(:match)
      .where(matches: { cohort_id: @cohort.id })
      .where("surveys.rating <= ?", 2)
      .order(created_at: :desc)

    @surveys_by_rating = Survey.joins(:match)
      .where(matches: { cohort_id: @cohort.id })
      .group(:rating)
      .count
      .transform_keys(&:to_i)
      .sort.to_h

    # Initialize missing ratings with 0 and ensure proper order
    @surveys_by_rating = (1..5).each_with_object({}) do |rating, hash|
      hash[rating] = @surveys_by_rating[rating] || 0
    end
  end

  def show_detailed_exceptions?
    super
  end

  class CohortsController < ApplicationController
    def show
      @cohort = Cohort.find(params[:id])
      render json: @cohort
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Cohort not found" }, status: :not_found
    end
  end

  def create
    @cohort = Cohort.new(cohort_params)
    @current_program = Program.find(@cohort.program_id)

    respond_to do |format|
      if @cohort.save
        format.html { redirect_to "/dashboard/admin/#{@cohort.program_id}", notice: "Cohort was successfully created." }
        format.json { render :show, status: :created, location: @cohort }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cohort.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @cohort.update(cohort_params)
        format.html { redirect_to cohorts_path, notice: "Cohort was successfully updated." }
        format.json { render :show, status: :ok, location: @cohort }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cohort.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @cohort.destroy!

    respond_to do |format|
      format.html { redirect_to cohorts_path, notice: "Cohort was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_cohort
    @cohort = Cohort.find(params[:id])
  end

  def dashboard
    @cohort = Cohort.find(params[:id])
    @low_rated_surveys = Survey.joins(:match)
      .where(matches: { cohort_id: @cohort.id })
      .where("surveys.rating < ?", 2)
      .order(created_at: :desc)
  end

  def cohort_params
    params.require(:cohort).permit(:program_id, :cohort_name, :description, :start_date, :end_date, :creator_id,
                                   :contact_id, :required_meetings, :shortlist_start_time, :shortlist_end_time)
  end
end
