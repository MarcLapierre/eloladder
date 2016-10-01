Rails.application.routes.draw do
  get 'home/index'

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  resources :leagues, only: [:index, :show, :new, :create, :edit, :update]
  post 'leagues/:id/add_match_result', to: 'leagues#add_match_result', as: :league_add_match_result

  resources :invitations, only: [:create, :show]
  post 'invitations/accept/:token', to: 'invitations#accept', as: :invitation_accept
  post 'invitations/decline/:token', to: 'invitations#decline', as: :invitation_decline

  root to: "home#index"
end
