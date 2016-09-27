class League::Create < ActiveOperation::Base
  input :league, accepts: League, required: true

  before do
    halt unless league.valid?
  end

  def execute
    league.save!
    league.players.create!(user: league.user)
    league
  end
end
