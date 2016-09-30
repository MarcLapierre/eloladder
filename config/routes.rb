Rails.application.routes.draw do
  get 'home/index'

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  resources :leagues, only: [:index, :show, :new, :create, :edit, :update]

  resources :invitations, only: [:create, :show]
  post 'invitations/accept/:token', to: 'invitations#accept', as: :invitation_accept
  post 'invitations/decline/:token', to: 'invitations#decline', as: :invitation_decline

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"
end
