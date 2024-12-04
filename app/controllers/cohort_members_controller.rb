class CohortMembersController < ApplicationController
  before_action :set_cohort_member, only: %i[show edit update destroy]

  # GET /cohort_members or /cohort_members.json
  def index
    if params[:cohort_id]
      @cohort = Cohort.find(params[:cohort_id])
      @cohort_members = @cohort.members.includes(:user)
    else
      @cohort_members = CohortMember.includes(:user).all
    end

    @mentors = @cohort_members.select { |member| member.role == "mentor" }
    @mentees = @cohort_members.select { |member| member.role == "mentee" }
  end

  # GET /cohort_members/1 or /cohort_members/1.json
  def show; end

  # GET /cohort_members/new
  def new
    @cohort_member = CohortMember.new
    @cohort = Cohort.find(params[:cohort_id])
    @current_program = Program.find_by(creator_id: current_user.id)
  end

  # GET /cohort_members/1/edit
  def edit; end

  # POST /cohort_members or /cohort_members.json
  def create
    cohort_id = params[:cohort_member][:cohort_id]

    # Split, clean up, and process emails from the form's hidden fields
    mentor_emails = extract_emails(params[:cohort_member][:mentor_emails])
    mentee_emails = extract_emails(params[:cohort_member][:mentee_emails])

    # Create cohort members for mentors and mentees
    mentor_emails.each { |email| create_cohort_member(email, cohort_id, "mentor") }
    mentee_emails.each { |email| create_cohort_member(email, cohort_id, "mentee") }

    respond_to do |format|
      format.html { redirect_to dashboard_path(role: "admin"), notice: "Mentors and mentees were successfully added." }
      format.json { render json: { message: "Mentors and mentees were successfully added." }, status: :created }
    end
  end

  # POST /cohort_members/add_email
  def add_email
    cohort_id = params[:cohort_id]
    email = params[:email]
    role = params[:role]

    if create_cohort_member(email, cohort_id, role)
      render json: { message: "Email added successfully" }, status: :ok
    else
      render json: { error: "Failed to add email" }, status: :unprocessable_entity
    end
  end

  # POST /cohort_members/delete_email
  def delete_email
    cohort_id = params[:cohort_id]
    email = params[:email]
    role = params[:role]

    cohort_member = CohortMember.joins(:user)
                                .where(users: { email: })
                                .find_by(cohort_id:, role:)

    if cohort_member&.destroy
      render json: { message: "Email deleted successfully" }, status: :ok
    else
      render json: { error: "Failed to delete email" }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /cohort_members/1 or /cohort_members/1.json
  def update
    respond_to do |format|
      if @cohort_member.update(cohort_member_params)
        format.html { redirect_to cohort_member_url(@cohort_member), notice: "Cohort member was successfully updated." }
        format.json { render :show, status: :ok, location: @cohort_member }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cohort_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cohort_members/1 or /cohort_members/1.json
  def destroy
    @cohort_member.destroy!

    respond_to do |format|
      format.html { redirect_to cohort_members_url, notice: "Cohort member was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cohort_member
    @cohort_member = CohortMember.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def cohort_member_params
    params.require(:cohort_member).permit(:email, :cohort_id, :role)
  end

  # Helper method to find or create a cohort member and associate them with a cohort/change or update role
  def create_cohort_member(email, cohort_id, role)
    cm = CohortMember.find_or_initialize_by(email:)
    cm.cohort_id = cohort_id
    cm.role = role

    cm.save!

    CohortMemberMailer.welcome_mail(cm).deliver_later!
  end

  # Helper method to split, clean, and format email strings
  def extract_emails(email_string)
    email_string.to_s.split(",").map(&:strip).reject(&:empty?)
  end
end
