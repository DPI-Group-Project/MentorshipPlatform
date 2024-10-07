class DashboardController < ApplicationController
  before_action :dashboard_params, only: [:show]
  def show
    @role = params[:role]

    case @role
    when 'Mentor'
      @mentors_data = CohortMember.where(role: 'Mentor')
    when 'Mentee'
      @mentees_data = CohortMember.where(role: 'Mentee')
    when 'Admin'
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