class CohortsController < ApplicationController
  before_action :set_cohort, only: %i[show edit update destroy]

  # GET /cohorts or /cohorts.json
  def index
    @cohorts = Cohort.all
  end

  # GET /cohorts/1 or /cohorts/1.json
  def show
  end

  # GET /cohorts/new
  def new
    @cohort = Cohort.new
  end

  # GET /cohorts/1/edit
  def edit
  end

  # POST /cohorts or /cohorts.json
  def create
    @cohort = Cohort.new(cohort_params)

    respond_to do |format|
      if @cohort.save
        format.html { redirect_to "/dashboard/admin/#{@cohort.program_id}", notice: 'Cohort was successfully created.' }
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
        format.html { redirect_to cohort_url(@cohort), notice: 'Cohort was successfully updated.' }
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
      format.html { redirect_to cohorts_url, notice: 'Cohort was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cohort
    @cohort = Cohort.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def cohort_params
    params.require(:cohort).permit(:program_id, :cohort_name, :description, :start_date, :end_date, :creator_id,
                                   :contact_id, :required_meetings, :shortlist_start_time, :shortlist_end_time)
  end
end
