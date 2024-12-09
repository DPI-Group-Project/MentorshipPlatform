# Preview all emails at http://localhost:3000/rails/mailers/survey_mailer
class SurveyMailerPreview < ActionMailer::Preview
  def notify_admin_of_survey_creation
    survey = Survey.first
    SurveyMailer.with(survey: survey).notify_admin_of_survey_creation
  end
end