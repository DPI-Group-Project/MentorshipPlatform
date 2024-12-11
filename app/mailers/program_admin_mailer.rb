class ProgramAdminMailer < ApplicationMailer
	def admin_created_email(admin_email, program_name)
    @program_name = program_name
    mail(to: admin_email, subject: 'MentE: You have been added as an Admin')
  end
end
