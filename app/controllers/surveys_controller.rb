class SurveysController < ApplicationController
  def new
    @survey = Survey.new
  end

  def create
    @survey = Survey.new(survey_params)
    if @survey.save
      redirect_to dashboard_path(role: current_user.role), notice: 'Survey was successfully created.'
    else
      render :new
    end
  end

  private

  def survey_params
    params.require(:survey).permit(
      :match_id, :responsive, :rating, :experience, 
      :responsive_reason, :experience_reason, :additional_note
    )
  end
end
