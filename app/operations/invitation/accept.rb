class Invitation::Accept < ActiveOperation::Base
  input :token, accepts: String, type: :keyword, required: true
  input :user, accepts: User, type: :keyword, required: true

  before do
    halt unless existing_invitation
  end

  def execute
    existing_invitation.update_attributes!(
      user: user,
      state: 'accepted',
      accepted_at: Time.now.utc
    )
    existing_invitation
  end

  succeeded do
    output.league.players.create!(user: user)
  end

  private

  def existing_invitation
    @invitation ||= Invitation.pending.where(token: token).first
  end
end
