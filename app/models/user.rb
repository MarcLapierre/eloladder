class User < ApplicationRecord
  include Gravtastic
  gravtastic

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable

  has_many :players
  has_many :leagues, through: :players
  has_many :invitations

  validates :first_name, presence: true
  validates :last_name, presence: true

  after_commit :claim_invitations, on: :create

  private

  def claim_invitations
    Invitation::Claim.call(user: self) if persisted?
  end
end
