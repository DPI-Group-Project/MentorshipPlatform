class DashboardController < ApplicationController
  before_action :dashboard_params, only: [:show]
  def show
    @role = params[:role].downcase    
    #Loads up data when role is valid
    if ['mentor', 'mentee'].include? (@role) then
      @mentors_data = User.mentors_in_cohort(current_user.cohort.id)
      @mentees_data = CohortMember.where(role: 'mentee')
    elsif ['admin'].include? (@role) then
      @admin_data = ProgramAdmin.find_by(id: current_user.id)
      @programs_by_admin = Program.where(creator_id: current_user.id)
      if params[:program_id].present?
        @current_program = Program.find_by(id: params[:program_id])
        @cohorts = Cohort.where(program_id: params[:program_id])
      else
        @current_program = Program.where(creator_id: current_user.id).sample
        @cohorts = Cohort.where(program_id: @current_program.id)
      end
    else
      redirect_to root_path, alert: 'Invalid role specified.'
    end
  end

  private
  # Only allow a list of trusted parameters through.
  def dashboard_params
    params.permit(:role, :program_id)
  end
end