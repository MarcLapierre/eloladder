class UserMailer < ApplicationMailer
  def invitation_email(email, league_name, token)
    @league_name = league_name
    @token = token
    mail(to: email, subject: "You've been invited to join #{league_name}")
  end
end
