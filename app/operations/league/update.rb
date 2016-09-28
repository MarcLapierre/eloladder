class League::Update < ActiveOperation::Base
  input :league, accepts: League, type: :keyword, required: true
  input :name, accepts: String, type: :keyword
  input :description, accepts: String, type: :keyword
  input :rules, accepts: String, type: :keyword
  input :website_url, accepts: String, type: :keyword
  input :logo_url, accepts: String, type: :keyword

  before do
    halt league unless league.persisted?
  end

  def execute
    success = league.update_attributes({
      name: name,
      description: description,
      rules: rules,
      website_url: website_url,
      logo_url: logo_url
    }.compact)

    halt league unless success
    league
  end
end
