class Invitation < ApplicationRecord
  belongs_to :user
  belongs_to :league

  STATES = %w{pending accepted declined}

  validates :league, presence: true
  validates :email, presence: true
  validates :token, presence: true
  validates :state, inclusion: STATES

end
