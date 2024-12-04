# Preview all emails at http://localhost:3000/rails/mailers/match_mailer
class MatchMailerPreview < ActionMailer::Preview
  def match_created
    match = Match.first
    MatchMailer.with(match: match).match_created
  end
end