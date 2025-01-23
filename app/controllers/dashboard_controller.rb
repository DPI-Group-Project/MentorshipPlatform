class DashboardController < ApplicationController
  include DashboardHelper
  before_action :dashboard_params, only: [:show]
  helper_method :progress_message, :progress_message_mentor

  def show
    @role = params[:role].downcase

    if valid_role?
      load_data_for_role
    else
      redirect_to root_path, alert: "Invalid role specified."
    end
  end

  def progress_message_mentor(progress)
    progress_message_helper(progress, mentor_progress_messages)
  end

  def progress_message(progress)
    progress_message_helper(progress, mentee_progress_messages)
  end

  def create_program_admin
    @current_program = Program.find(current_user.program_admin.program_id)

    @admin_user = User.create(email: program_admin_params[:email],   first_name: program_admin_params[:first_name],
    last_name:  program_admin_params[:last_name], password: "password")
    @program_admin = ProgramAdmin.new(user_id: @admin_user.id, program_id: @current_program.id, created_by_admin_id: current_user.id)

    if @program_admin.save
      ProgramAdminMailer.admin_created_email(@program_admin.admin&.email, @program_admin.admin&.first_name, @program_admin.admin&.last_name, @current_program.name).deliver_later
      redirect_to dashboard_path(role: "admin"), notice: "Program admin was successfully created."
    else
      render :show, alert: "Failed to create program admin."
    end
  end

  def delete_program_admin
    ActiveRecord::Base.transaction do
      program_admin = ProgramAdmin.find(params[:id])
      user = program_admin.admin
      program_admin.destroy!
      user.delete
    end

    redirect_to dashboard_path(role: "admin"), notice: "Admin deleted successfully."
  end

  private

  def valid_role?
    %w[mentor mentee admin].include?(@role)
  end

  def load_data_for_role
    case @role
    when "mentor", "mentee"
      load_user_data
    when "admin"
      load_admin_data
    end
  end

  def load_user_data
    @shortlist_time = current_user.cohort.shortlist_creation_open?
    @mentors_data = User.mentors_in_cohort(current_user.cohort.id)
    @mentees_data = CohortMember.where(role: "mentee")
    @meetings = user_meetings
    @meeting_dates = @meetings.map { |meeting| meeting.date.strftime("%Y-%m-%d") }
    @upcoming_meeting = @meetings.select { |meeting| meeting.date >= Time.zone.today }.min_by(&:date)
    @required_meetings_count = current_user.cohort.required_meetings
    @past_meeting_count = @meetings.count { |meeting| meeting.date < Time.zone.today }
    @progress = calculate_progress(@past_meeting_count, @required_meetings_count)
    @remaining_meetings = @required_meetings_count - @meetings.count
    load_mentee_meeting_counts if @role == "mentor"
    @survey_count = Survey.count_by_user(current_user)
  end

  def load_admin_data
    @admin_data = ProgramAdmin.find_by(user_id: current_user.id)
    @program_admin = ProgramAdmin.new
    @current_program = Program.find(current_user.program_admin.program_id)
    @cohorts = Cohort.where(program_id: @current_program.id)
    @program_admins = ProgramAdmin.where(program_id: @current_program&.id)
  end

  def user_meetings
    current_user.mentor ? current_user.mentor.meetings : current_user.mentees.flat_map(&:meetings)
  end

  def calculate_progress(past, required)
    ((past.to_f / required) * 100).round(0)
  end

  def load_mentee_meeting_counts
    @meeting_counts_with_mentee = mentee_meeting_counts
    @past_meeting_counts_with_mentee = mentee_past_meeting_counts
    @total_meetings_count = @meeting_counts_with_mentee.values.sum
    @total_past_meeting_count = @past_meeting_counts_with_mentee.values.sum
  end

  def mentee_meeting_counts
    mentee_meeting_data { |mentee| meetings_with_mentee(mentee).count }
  end

  def mentee_past_meeting_counts
    mentee_meeting_data { |mentee| meetings_with_mentee(mentee).where("meetings.date < ?", Date.today).count }
  end

  def mentee_meeting_data
    current_user.current_user_mentees.each_with_object({}) do |mentee, counts|
      counts[mentee.id] = yield(mentee)
    end
  end

  def meetings_with_mentee(mentee)
    Meeting.joins(:match).where(matches: { mentor_id: current_user.id, mentee_id: mentee.id })
  end

  def current_program
    Program.find_by(id: params[:program_id]) || Program.find_by(contact_id: current_user.id)
  end

  def progress_message_helper(progress, messages)
    messages.each { |range, message| return message if range === progress }
    "Let’s keep pushing forward! Every step counts. ☀"
  end

  def dashboard_params
    params.permit(:role, :program_id)
  end

  def program_admin_params
    params.require(:program_admin).permit(:first_name, :last_name, :email, :program_id)
  end
end
