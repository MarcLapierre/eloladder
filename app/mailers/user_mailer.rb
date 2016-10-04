class UserMailer < ApplicationMailer
  def invitation_email(invitation)
    @league_name = invitation.league.name
    @url = Rails.application.routes.url_helpers.invitation_path(invitation)
    mail(to: invitation.email, subject: "You've been invited to join #{@league_name}")
  end
end
