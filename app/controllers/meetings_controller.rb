class MeetingsController < ApplicationController
  before_action :set_meeting, only: %i[show edit update destroy]

  # GET /meetings or /meetings.json
  def index
    @match = Match.where("mentee_id = :id OR mentor_id = :id", id: current_user.id).first
    @meetings = @match.meetings.order(:date)
    @mentor = @match.mentor
    @required_meetings_count = @match.cohort.required_meetings
    @remaining_meetings = @required_meetings_count - @meetings.count

    # Fetch all mentees associated with the mentor
    @mentees = Match.where(mentor_id: current_user.id).map(&:mentee)

    # Fetch meetings and related data for each mentee
    @mentee_meetings = @mentees.each_with_object({}) do |mentee, hash|
      # Find the match between the current mentor and mentee
      match = Match.find_by(mentor_id: current_user.id, mentee_id: mentee.id)

      if match
        meetings = match.meetings.order(:date)
        required_meetings_count = match.cohort.required_meetings
        remaining_meetings = required_meetings_count - meetings.count

        hash[mentee.id] = {
          meetings: meetings,
          remaining_meetings: remaining_meetings,
          required_meetings_count: required_meetings_count
        }
      else
        hash[mentee.id] = {
          meetings: [],
          remaining_meetings: 0,
          required_meetings_count: 0
        }
      end
    end

  end

  # GET /meetings/1 or /meetings/1.json
  def show
    @match = Match.where("mentee_id = :id OR mentor_id = :id", id: current_user.id).first
    @meetings = @match.meetings.order(:date)
    @mentor = @match.mentor
    @required_meetings_count = @match.cohort.required_meetings
    @remaining_meetings = @required_meetings_count - @meetings.count

    # Fetch all mentees associated with the mentor
    @mentees = Match.where(mentor_id: current_user.id).map(&:mentee)

    # Fetch meetings and related data for each mentee
    @mentee_meetings = @mentees.each_with_object({}) do |mentee, hash|
      # Find the match between the current mentor and mentee
      match = Match.find_by(mentor_id: current_user.id, mentee_id: mentee.id)

      if match
        meetings = match.meetings.order(:date)
        required_meetings_count = match.cohort.required_meetings
        remaining_meetings = required_meetings_count - meetings.count

        hash[mentee.id] = {
          meetings: meetings,
          remaining_meetings: remaining_meetings,
          required_meetings_count: required_meetings_count
        }
      else
        hash[mentee.id] = {
          meetings: [],
          remaining_meetings: 0,
          required_meetings_count: 0
        }
      end
    end

  end

  # GET /meetings/new
  def new
    @meeting = Meeting.new
  end

  # GET /meetings/1/edit
  def edit; end

  # POST /meetings or /meetings.json
  def create
    # 현재 사용자가 멘토인지 멘티인지 확인하고 match를 찾습니다.
    @match = Match.find_by("mentee_id = :id OR mentor_id = :id", id: current_user.id)

    # 새로운 미팅 객체를 생성하고 match_id를 설정합니다.
    @meeting = Meeting.new(meeting_params)
    @meeting.match_id = @match.id if @match.present?

    respond_to do |format|
      if @meeting.save
        format.html { redirect_to meeting_url(@meeting), notice: "Meeting was successfully created." }
        format.json { render :index, status: :created, location: @meeting }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /meetings/1 or /meetings/1.json
  def update
    respond_to do |format|
      if @meeting.update(meeting_params)
        format.html { redirect_to meeting_url(@meeting), notice: "Meeting was successfully updated." }
        format.json { render :index, status: :ok, location: @meeting }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meetings/1 or /meetings/1.json
  def destroy
    @meeting.destroy!

    respond_to do |format|
      format.html { redirect_to meetings_url, notice: "Meeting was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_meeting
    @meeting = Meeting.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def meeting_params
    params.require(:meeting).permit(:date, :time, :notes, :location, :location_type)
  end
end
