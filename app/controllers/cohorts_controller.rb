class CohortsController < ApplicationController
  before_action :set_cohort, only: %i[show edit update destroy]
  before_action :set_program, only: %i[index new create edit]

  # GET /cohorts or /cohorts.json
  def index
    if params[:program_id].present?
      @program = Program.find(params[:program_id])
      @cohorts = @program.cohorts
    else
      @cohorts = Cohort.all
    end
    @cohort = Cohort.new
  end

  # GET /cohorts/new
  def new
    @cohort = Cohort.new
  end

  # GET /cohorts/1/edit
  def edit
    @current_program = @cohort.program
  end

  # POST /cohorts or /cohorts.json
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

  # PATCH/PUT /cohorts/1 or /cohorts/1.json
  def update
    respond_to do |format|
      if @cohort.update(cohort_params)
        format.html { redirect_to program_cohorts_path(@cohort.program), notice: "Cohort was successfully updated." }
        format.json { render :show, status: :ok, location: @cohort }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cohort.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cohorts/1 or /cohorts/1.json
  def destroy
    @cohort.destroy!

    respond_to do |format|
      format.html { redirect_to program_cohorts_path(@cohort.program), notice: "Cohort was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  

  private

  def set_program
    @current_program = Program.find_by(id: params[:program_id])
  end

  def set_cohort
    @cohort = Cohort.find(params[:id])
  end

  def cohort_params
    params.require(:cohort).permit(:program_id, :cohort_name, :description, :start_date, :end_date, :creator_id,
                                   :contact_id, :required_meetings, :shortlist_start_time, :shortlist_end_time)
  end
end
