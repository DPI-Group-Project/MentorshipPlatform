# Preview all emails at http://localhost:3000/rails/mailers/cohort_mailer
class CohortMailerPreview < ActionMailer::Preview
  def shortlist_start_notification
    user = User.first
    cohort = Cohort.first
    CohortMailer.with(user: user, cohort: cohort).shortlist_start_notification
  end

  def unmatched_notification
    user = User.first
    cohort = Cohort.first
    CohortMailer.with(user: user, cohort: cohort).unmatched_notification
  end

  def matching_complete_notification
    admin = ProgramAdmin.all.sample
    cohort = Cohort.first
    CohortMailer.with(admin: admin, cohort: cohort).matching_complete_notification
  end

  def two_week_warning
    cohort = Cohort.first
    admin_email = ProgramAdmin.first.admin.email
    CohortMailer.with(admin_email: admin_email, cohort: cohort).two_week_warning
  end

  def survey_reminder
    user = User.first
    cohort = Cohort.first
    admin = ProgramAdmin.first.admin.email
    admin_email = [nil, admin].sample
    CohortMailer.with(user: user, cohort: cohort, admin_email: admin_email).survey_reminder
  end
end