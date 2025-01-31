class ProgramAdminMailer < ApplicationMailer
  def admin_created_email
    @current_program = params[:current_program]
    @admin = params[:program_admin]
    @password = params[:password]
    @user = params[:user]
    # Format the email parameters for Resend
    email_params = {
      from: "onboarding@resend.dev",
      to: @user.email,
      subject: "MentE: You have been added as an Admin",
      html: render_to_string(template: "program_admin_mailer/admin_created_email") # Render the email template
    }

    # Log the Resend API request
    Rails.logger.info "Resend API Request: #{email_params.inspect}"

    # Send the email via Resend
    response = Resend::Emails.send(email_params)

    # Log the Resend API response
    Rails.logger.info "Resend API Response: #{response.inspect}"
  end
end
