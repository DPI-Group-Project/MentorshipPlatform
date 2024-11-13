class MeetingsController < ApplicationController
  before_action :set_meeting, only: %i[ show edit update destroy ]

  # GET /meetings or /meetings.json
  def index
    @match = Match.where('mentee_id = :id OR mentor_id = :id', id: current_user.id).first
    @meetings = @match.meetings.order(:date)
    @mentor = @match.mentor
    @required_meetings_count = @match.cohort.required_meetings
    @remaining_meetings = @required_meetings_count - @meetings.count
  end

  # GET /meetings/1 or /meetings/1.json
  def show
    @match = Match.where('mentee_id = :id OR mentor_id = :id', id: current_user.id).first
    @meetings = @match.meetings.order(:date)
    @mentor = @match.mentor
    @required_meetings_count = @match.cohort.required_meetings
    @remaining_meetings = @required_meetings_count - @meetings.count
  end

  # GET /meetings/new
  def new
    @meeting = Meeting.new
  end

  # GET /meetings/1/edit
  def edit
  end

  # POST /meetings or /meetings.json
  def create
    @match = Match.find_by(mentee_id: current_user.id)
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
      params.require(:meeting).permit(:date, :time, :notes, :location)
    end
    
end
