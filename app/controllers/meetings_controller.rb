  class MeetingsController < ApplicationController
    before_action :set_meeting, only: %i[show edit update destroy]
    before_action :find_match, only: %i[index show edit update destroy]
    # before_action :meeting_variables, only: %i[index show]

    # GET /meetings or /meetings.json
    def index
      @meetings = @match.meetings.order(:date)
      @mentor = @match.mentor
      @required_meetings_count = @match.cohort.required_meetings
      @remaining_meetings = @required_meetings_count - @meetings.count

      @mentees = Match.where(mentor_id: current_user.id).map(&:mentee)
      @mentee_meetings = mentee_meeting_data(@mentees)
    end

    # GET /meetings/1 or /meetings/1.json
    def show; end

    # GET /meetings/new
    def new
      @match = Match.find_by(id: params[:match_id])
      if @match.nil?
        redirect_to dashboard_path, alert: "Match not found. Please check your selection."
        return
      end
      @meeting = Meeting.new(match: @match)
    end

    # GET /meetings/1/edit
    def edit; end

    # POST /meetings or /meetings.json
    def create
      @meeting = Meeting.new(meeting_params)
      # @meeting.match_id = @match&.id

      respond_to do |format|
        if @meeting.save
          format.html { redirect_to meetings_path, notice: "Meeting was successfully created." }
          format.json { render :show, status: :created, location: @meeting }
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
          format.html { redirect_to meetings_path, notice: "Meeting was successfully updated." }
          format.json { render :show, status: :ok, location: @meeting }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @meeting.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /meetings/1 or /meetings/1.json
    def destroy
      @meeting.destroy
      respond_to do |format|
        format.html { redirect_to meetings_path, notice: "Meeting was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private

    def meeting_variables
      @meetings = @match.meetings.order(:date)
      @mentor = @match.mentor
      @required_meetings_count = @match.cohort.required_meetings
      @remaining_meetings = @required_meetings_count - @meetings.count

      @mentees = Match.where(mentor_id: current_user.id).map(&:mentee)
      @mentee_meetings = mentee_meeting_data(@mentees)
    end

    def find_match
      @match = if current_user.mentor?
                 Match.find_by(mentor_id: current_user.id)
               elsif current_user.mentee?
                 Match.find_by(mentee_id: current_user.id)
               end
    end

    # Set meeting for actions that require it
    def set_meeting
      @meeting = Meeting.find(params[:id])
      @match = @meeting.match
    end

    # Aggregate meeting data for mentees
    def mentee_meeting_data(mentees)
      mentees.each_with_object({}) do |mentee, hash|
        match = Match.find_by(mentor_id: current_user.id, mentee_id: mentee.id)
        next unless match

        meetings = match.meetings.order(:date)
        required_meetings_count = match.cohort.required_meetings
        remaining_meetings = required_meetings_count - meetings.count

        hash[mentee.id] = {
          meetings: meetings,
          remaining_meetings: remaining_meetings,
          required_meetings_count: required_meetings_count
        }
      end
    end

    # Strong parameters for meeting
    def meeting_params
      params.require(:meeting).permit(:date, :time, :notes, :location, :location_type, :match_id)
    end
  end
