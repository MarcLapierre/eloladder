class Invitation::Decline < ActiveOperation::Base
  input :token, accepts: String, type: :keyword, required: true
  input :user, accepts: User, type: :keyword, required: true

  before do
    halt unless existing_invitation
  end

  def execute
    existing_invitation.update_attributes!(
      user: user,
      state: 'declined',
      declined_at: Time.now.utc
    )
    existing_invitation
  end

  private

  def existing_invitation
    @invitation ||= Invitation.pending.where(token: token).first
  end
end
