class CohortMembersController < ApplicationController
  before_action :set_cohort_member, only: %i[ show edit update destroy ]

  # GET /cohort_members or /cohort_members.json
  def index
    @cohort_members = CohortMember.all
  end

  # GET /cohort_members/1 or /cohort_members/1.json
  def show
  end

  # GET /cohort_members/new
  def new
    @cohort_member = CohortMember.new
  end

  # GET /cohort_members/1/edit
  def edit
  end

  # POST /cohort_members or /cohort_members.json
  def create
    @cohort_member = CohortMember.new(cohort_member_params)

    respond_to do |format|
      if @cohort_member.save
        format.html { redirect_to cohort_member_url(@cohort_member), notice: "Cohort member was successfully created." }
        format.json { render :show, status: :created, location: @cohort_member }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cohort_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cohort_members/1 or /cohort_members/1.json
  def update
    respond_to do |format|
      if @cohort_member.update(cohort_member_params)
        format.html { redirect_to cohort_member_url(@cohort_member), notice: "Cohort member was successfully updated." }
        format.json { render :show, status: :ok, location: @cohort_member }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cohort_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cohort_members/1 or /cohort_members/1.json
  def destroy
    @cohort_member.destroy!

    respond_to do |format|
      format.html { redirect_to cohort_members_url, notice: "Cohort member was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cohort_member
      @cohort_member = CohortMember.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cohort_member_params
      params.require(:cohort_member).permit(:user_id, :cohort_id, :role)
    end
end
