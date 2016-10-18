class Invitation::Claim < ActiveOperation::Base
  input :user, accepts: User, type: :keyword, required: true

  def execute
    Invitation.pending.where(email: user.email).update_all(user_id: user.id)
  end
end
