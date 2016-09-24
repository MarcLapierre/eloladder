class Invitation::Create < ActiveOperation::Base
  input :league, accepts: League, type: :keyword, required: true
  input :email, accepts: String, type: :keyword, required: true

  before do
    halt if existing_invitation
  end

  def execute
    Invitation.create!(
      league: league,
      user: user,
      email: email,
      state: 'pending',
      token: generate_token
    )
  end

  # succeeded do
  #   UserMailer.invite_email(email).deliver_now
  # end

  private

  def existing_invitation
    if user
      invitation = Invitation.pending.where(user: user, league: league)
    end
    invitation ||= Invitation.pending.where(email: email, league: league)
    invitation.first
  end

  def user
    @user ||= User.find_by(email: email)
  end

  def generate_token
    loop do
      random_token = SecureRandom.hex(32)
      break random_token unless Invitation.exists?(token: random_token)
    end
  end
end
