class Invitation < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :league

  STATES = %w{pending accepted declined}

  STATES.each do |state|
    scope state, -> { where(state: state) }
  end

  validates :email, presence: true
  validates :token, presence: true
  validates :state, inclusion: STATES

  def to_param
    token
  end
end
