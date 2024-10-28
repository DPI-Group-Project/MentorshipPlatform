class CohortMemberMailer < ApplicationMailer
  def mentor_welcome_mail(cohort_member)
    @cohort_member = cohort_member
    @user = User.find_by(email: @cohort_member.email)
    @cohort = @cohort_member.cohort

    mail(to: @user.email,
         subject: 'Welcome to MentE!')
  end

  def mentee_welcome_mail(cohort_member)
    @cohort_member = cohort_member
    @user = User.find_by(email: @cohort_member.email)
    @cohort = @cohort_member.cohort

    mail(to: @user.email,
         subject: 'Welcome to MentE!')
  end
end
