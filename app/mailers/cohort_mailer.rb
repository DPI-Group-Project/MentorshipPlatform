class CohortMailer < ApplicationMailer
  def shortlist_start_notification(user, cohort)
    @user = user
    @cohort = cohort
    mail(to: @user.email, subject: "The Shortlist Period Has Started!")
  end

  def unmatched_notification(user, cohort)
    @user = user
    @cohort = cohort
    mail(to: @user.email, subject: "Please Log In to Select a Mentor")
  end

  def matching_complete_notification(admin, cohort)
    @admin = admin
    @cohort = cohort
    mail(to: @admin.email, subject: "MentE Matching Complete for #{@cohort.cohort_name}!")
  end

  def two_week_warning(admin_email, cohort)
    @cohort = cohort
    mail(to: admin_email, subject: "Two Weeks until #{@cohort.cohort_name} Ends!")
  end

  def survey_reminder(user, cohort, admin_email = nil)
    @user = user
    @cohort = cohort
    if admin_email
      mail(to: admin_email, subject: "Survey Reminder for #{@cohort.cohort_name}")
    else
      mail(to: @user.email, subject: "Survey Reminder for #{@cohort.cohort_name}")
    end
  end
end
