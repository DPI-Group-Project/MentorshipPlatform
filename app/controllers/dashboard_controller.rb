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
    else
      redirect_to root_path, alert: 'Invalid role specified.'
    end
  end

  private
  # Only allow a list of trusted parameters through.
  def dashboard_params
    params.permit(:role)
  end
end