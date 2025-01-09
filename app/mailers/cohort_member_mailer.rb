class CohortMemberMailer < ApplicationMailer
  def welcome_mail
    @cohort_member = params[:cohort_member]
    @cohort = @cohort_member.cohort

    mail(to: @cohort_member.email,
         subject: "Welcome to MentE!")
  end
end
