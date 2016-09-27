class UserMailerPreview < ActionMailer::Preview
  def invitation_email
    UserMailer.invitation_email('test@email.com', 'League Name', 'token123')
  end
end
