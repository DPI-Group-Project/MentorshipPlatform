class ProgramsController < ApplicationController
  before_action :set_program, only: %i[show edit update destroy]

  def index
    @program = Program.find(current_user.program_admin.program_id)
    @current_program = @program # Add this line
    @cohorts = @program.cohorts
  end
  
  def new
    @program = Program.new
  end

  def create
    @program = Program.new(program_params)

    respond_to do |format|
      if @program.save
        format.html { redirect_to program_url(@program), notice: "Program was successfully created." }
        format.json { render :show, status: :created, location: @program }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @program.update(program_params)
        format.html { redirect_to program_url(@program), notice: "Program was successfully updated." }
        format.json { render :show, status: :ok, location: @program }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @program.destroy!

    respond_to do |format|
      format.html { redirect_to programs_url, notice: "Program was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_program
    @program = Program.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def program_params
    params.require(:program).permit(:name, :description, :creator_id, :contact_id)
  end
end
