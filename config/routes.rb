Rails.application.routes.draw do
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'
  get '/logout', to: 'sessions#destroy'
  post '/tweets/search', to: 'tweets#search'
  resources :tweets, only: [:new, :index]
  root to: "users#index"
end
