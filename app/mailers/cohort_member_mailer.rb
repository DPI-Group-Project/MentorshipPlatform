class CohortMemberMailer < ApplicationMailer
  def mentor_welcome_mail(cohort_member)
    @cohort_member = cohort_member
    @user = User.find_by(email: @cohort_member.email)
    @cohort = @cohort_member.cohort

    mail(to: email_address_with_name(@user.email, @user.first_name),
         subject: "Welcome to MentE, #{@user.first_name}!")
  end

  def mentee_welcome_mail(cohort_member)
    @cohort_member = cohort_member
    @user = User.find_by(email: @cohort_member.email)
    @cohort = @cohort_member.cohort

    mail(to: email_address_with_name(@user.email, @user.first_name),
         subject: "Welcome to MentE, #{@user.first_name}!")
  end
end
