class MatchMailer < ApplicationMailer
	def match_created(match)
    @match = match
    mail(to: @match.mentor.email, subject: 'New Match Created')
    mail(to: @match.mentee.email, subject: 'New Match Created')
  end
end
