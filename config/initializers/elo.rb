Elo.configure do |config|
  config.default_rating = 1500
  config.pro_rating_boundry = 2400
  config.starter_boundry = 30

  config.k_factor(40) { games_played < 30 }
  config.k_factor(10) { games_played > 30 && (pro? || rating > 2400) }
  config.default_k_factor = 20
  config.use_FIDE_settings = false
end
