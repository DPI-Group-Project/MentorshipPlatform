class SurveyMailer < ApplicationMailer
  def notify_admin_of_survey_creation(survey)
    @survey = survey

    @admin = User.find_by(id: Cohort.find_by(id: survey.match.cohort_id).creator_id)
    mail(to: @admin.email, subject: "New Survey Created")
  end
end
