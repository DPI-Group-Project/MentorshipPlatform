class DashboardController < ApplicationController
  before_action :dashboard_params, only: [:show]
  helper_method :progress_message

  def show
    @role = params[:role].downcase

    #Loads up data when role is valid
    if ['mentor', 'mentee'].include? (@role) then
      @shortlist_time = current_user.cohort.shortlist_creation_open?
      @mentors_data = User.mentors_in_cohort(current_user.cohort.id)
      @mentees_data = CohortMember.where(role: 'mentee')

      @meetings = current_user.mentor ? current_user.mentor.meetings : current_user.mentees.map(&:meetings).flatten
      @meeting_dates = @meetings.map { |meeting| meeting.date.strftime('%Y-%m-%d') }
      @upcoming_meeting = @meetings.select { |meeting| meeting.date >= Date.today }.min_by(&:date)
      @required_meetings_count = current_user.cohort.required_meetings
      @past_meeting_count = @meetings.count { |meeting| meeting.date < Date.today }
      @progress = ((@past_meeting_count.to_f / @required_meetings_count) * 100).round(0)

    elsif ['admin'].include? (@role) then
      @admin_data = ProgramAdmin.find_by(id: current_user.id)
      @programs_by_admin = Program.where(creator_id: current_user.id)
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

  def progress_message(progress)
    case progress
    when 0
      "You’ve taken the first step! Excited for the journey ahead. 🎉"
    when 1..15
      "Keep going! The journey has just begun. 🚶‍♂️"
    when 16..32
      "Great start! You’ve crossed the first milestone. 👍"
    when 33..49
      "You’re moving smoothly! Already a third of the way there. 🚀"
    when 50..65
      "Halfway through! Getting here is an achievement itself. 💪"
    when 66..82
      "Almost there! The finish line is in sight. 👀"
    when 83..99
      "The final step is just around the corner! Keep going! 🌟"
    when 100
      "You’ve completed the entire journey! Congratulations on a job well done! 🎊👏"
    else
      "Let's keep pushing forward! Every step counts. 🌈"
    end
  end


  private
  # Only allow a list of trusted parameters through.
  def dashboard_params
    params.permit(:role, :program_id)
  end
end