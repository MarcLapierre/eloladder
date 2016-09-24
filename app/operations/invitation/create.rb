module Invitation
  class Create < ActiveOperation::Base
    # input :league, accepts: League, keyword: true, required: true
    # input :email, accepts: String, keyword: true, required: true
    #
    # before do
    #   halt if existing_invitation
    # end
    #
    # def execute
    #   Invitation.create!(
    #     league: league,
    #     user: user,
    #     email: email,
    #     state: 'pending',
    #     token: generate_token
    #   )
    # end
    #
    # succeeded do
    #   UserMailer.invite_email(email).deliver_now
    # end
    #
    # private
    #
    # def existing_invitation
    #   if user
    #     invitation = Invitation.pending.where(user: user, league: league)
    #   end
    #   invitation ||= Invitation.pending.where(email: email, league: league)
    # end
    #
    # def user
    #   @user ||= User.where(email: email)
    # end
    #
    # def generate_token
    #   loop do
    #     random_token = SecureRandom.hex(32)
    #     break random_token unless Invitation.exists?(token: random_token)
    #   end
    # end
  end
end
