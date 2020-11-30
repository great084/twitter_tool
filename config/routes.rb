Rails.application.routes.draw do
  resources :tweets, only: [:show,:index]
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'
  get '/logout', to: 'sessions#destroy'
  root to: "users#index"
end
