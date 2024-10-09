class DashboardController < ApplicationController
  before_action :dashboard_params, only: [:show]
  def show
    @role = params[:role].downcase    
    #Loads up data when role is valid
    if ['mentor', 'mentee', 'admin'].include? (@role) then
      @mentors_data = User.mentors_in_cohort(current_user.cohort)
      @mentees_data = CohortMember.where(role: 'Mentee')
      @admins_data = ProgramAdmin.all
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