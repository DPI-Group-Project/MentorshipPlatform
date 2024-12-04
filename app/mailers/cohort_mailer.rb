class CohortMailer < ApplicationMailer
  def shortlist_start_notification
    @user = params[:user]
    @cohort = params[:cohort]
    mail(to: @user.email, subject: "The Shortlist Period Has Started!")
  end

  def unmatched_notification
    @user = params[:user]
    @cohort = params[:cohort]
    mail(to: @user.email, subject: "Please Log In to Select a Mentor")
  end

  def matching_complete_notification
    @admin = params[:admin]
    @cohort = params[:cohort]
    mail(to: @admin.email, subject: "MentE Matching Complete for #{@cohort.cohort_name}!")
  end

  def two_week_warning
    @cohort = params[:cohort]
    admin_email = params[:admin_email]
    mail(to: admin_email, subject: "Two Weeks until #{@cohort.cohort_name} Ends!")
  end

  def survey_reminder
    @user = params[:user]
    @cohort = params[:cohort]
    admin_email = nil || params[:admin_email]
    if admin_email
      mail(to: admin_email, subject: "Survey Reminder for #{@cohort.cohort_name}")
    else
      mail(to: @user.email, subject: "Survey Reminder for #{@cohort.cohort_name}")
    end
  end
end