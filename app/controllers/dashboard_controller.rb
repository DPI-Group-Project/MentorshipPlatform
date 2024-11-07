class DashboardController < ApplicationController
  before_action :dashboard_params, only: [:show]
  def show
    @role = params[:role].downcase

    # Loads up data when role is valid
    if %w[mentor mentee].include?(@role)
      @shortlist_time = current_user.cohort.shortlist_creation_open?
      @mentors_data = User.mentors_in_cohort(current_user.cohort.id)
      @mentees_data = CohortMember.where(role: 'mentee')
    elsif ['admin'].include?(@role)
      @admin_data = ProgramAdmin.find_by(email: current_user.email)
      @programs_by_admin = current_user.assigned_programs
      @program_admin = ProgramAdmin.new
      if params[:program_id].present?
        @current_program = Program.find_by(id: params[:program_id])
        @cohorts = Cohort.where(program_id: params[:program_id])
      else
        @current_program = Program.find_by(creator_id: current_user.id)
        @cohorts = Cohort.where(program_id: @current_program.id)
      end
    else
      redirect_to root_path, alert: 'Invalid role specified.'
    end
  end

  def create_program_admin
    if params[:program_id].present?
      @current_program = Program.find_by(id: params[:program_id])
      @cohorts = Cohort.where(program_id: params[:program_id])
    else
      @current_program = Program.find_by(creator_id: current_user.id)
      @cohorts = Cohort.where(program_id: @current_program.id)
    end

    @program_admin = create_admin(program_admin_params[:email], @current_program.id)

    respond_to do |format|
      if @program_admin.save
        format.html { redirect_to dashboard_path(role: 'admin'), notice: 'Program admin was successfully created.' }
        format.js   # Optional, if you want to handle JS responses (e.g., to close the modal via JS)
      else
        format.html { render :show, alert: 'Failed to create program admin.' }
        format.js   # Optional, for JS response on failure
      end
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def dashboard_params
    params.permit(:role, :program_id)
  end

  def program_admin_params
    params.require(:program_admin).permit(:email, :program_id)
  end

  def create_admin(email, program_id)
    ProgramAdmin.create(email:, program_id:)
  end
end
