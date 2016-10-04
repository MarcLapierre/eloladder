class UserMailerPreview < ActionMailer::Preview
  def invitation_email
    UserMailer.invitation_email(Invitation.first)
  end
end
