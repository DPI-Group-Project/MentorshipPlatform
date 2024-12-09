# Preview all emails at http://localhost:3000/rails/mailers/cohort_member_mailer
class CohortMemberMailerPreview < ActionMailer::Preview
  def welcome_mail
    cohort_member = CohortMember.first
    CohortMemberMailer.with(cohort_member: cohort_member).welcome_mail
  end
end