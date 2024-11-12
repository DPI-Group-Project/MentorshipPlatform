class CohortMailer < ApplicationMailer
	def shortlist_start_notification(user, cohort)
    @user = user
    @cohort = cohort
    mail(to: @user.email, subject: 'The Shortlist Period Has Started!')
  end

	def unmatched_notification(user, cohort)
		@user = user
		@cohort = cohort
		mail(to: @user.email, subject: 'Please Log In to Select a Mentor')
	end
	
	def matching_complete_notification(admin, cohort)
		@admin = admin
		@cohort = cohort
		mail(to: @admin.email, subject: 'Cohort Matching Complete')
	end
end
