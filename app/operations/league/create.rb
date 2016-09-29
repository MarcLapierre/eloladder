class League::Create < ActiveOperation::Base
  input :user, accepts: User, type: :keyword
  input :name, accepts: String, type: :keyword
  input :description, accepts: String, type: :keyword
  input :rules, accepts: String, type: :keyword
  input :website_url, accepts: String, type: :keyword
  input :logo_url, accepts: String, type: :keyword

  def execute
    league = League.new(
      name: name,
      description: description,
      rules: rules,
      website_url: website_url,
      logo_url: logo_url
    )

    halt league unless league.valid?

    league.save!
    league.players.create!(user: user, owner: true)
    league
  end
end
