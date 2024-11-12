class SurveyMailer < ApplicationMailer
	def survey_created_notification(admin, survey)
		@survey = survey
		@admin = admin
		mail(
			to: @admin.email,
			subject: "New Survey Created for #{survey.program.name}"
		)
	end
end
