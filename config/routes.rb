Rails.application.routes.draw do
  get 'home/index'
  get 'home/plans'

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  resources :leagues, only: [:index, :show, :new, :create, :edit, :update]
  get 'leagues/:id/enter_match_result', to: 'leagues#enter_match_result', as: :league_enter_match_result
  post 'leagues/:id/add_match_result', to: 'leagues#add_match_result', as: :league_add_match_result
  post 'leagues/:id/invite', to: 'leagues#invite', as: :league_invite

  resources :invitations, only: [:show]
  post 'invitations/accept/:token', to: 'invitations#accept', as: :invitation_accept
  post 'invitations/decline/:token', to: 'invitations#decline', as: :invitation_decline

  root to: "home#index"
end
