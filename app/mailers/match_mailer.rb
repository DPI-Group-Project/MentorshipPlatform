class MatchMailer < ApplicationMailer
	def match_created(match)
    @match = match
    mail(to: @match.mentor.email, subject: 'You Have Been Matched!')
    mail(to: @match.mentee.email, subject: 'You Have Been Matched!')
  end
end
