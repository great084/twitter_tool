Rails.application.routes.draw do
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'
  get '/logout', to: 'sessions#destroy'
  resources :tweets, only: [:index]
  root to: "users#index"
end
