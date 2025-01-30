class ProgramAdminMailer < ApplicationMailer
  def admin_created_email
    @current_program = params[:current_program]
    @admin = params[:program_admin]
    @password = params[:password]
    @user = params[:user]
    mail(to: @user.email, subject: "MentE: You have been added as an Admin")
  end
end
