class CohortMemberMailer < ApplicationMailer
  def welcome_signup
    @user = params[:user]
    @role = params[:role]
    @cohort = params[:cohort]
    if @role == 'mentee'
      mail(to: email_address_with_name(@user.email, @user.first_name)) do |format|
        format.html { render layout: 'mentee_welcome_mail' }
        format.text
      end
    elsif @role == 'mentor'
      mail(to: email_address_with_name(@user.email, @user.first_name)) do |format|
        format.html { render layout: 'mentor_welcome_mail' }
        format.text
      end
    end
  end
end
