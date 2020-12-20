Rails.application.routes.draw do
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'
  get '/logout', to: 'sessions#destroy'
  post '/tweets/search', to: 'tweets#search'
  post '/tweets/retweet', to: 'tweets#retweet'
  resources :tweets, only: [:new, :index,:show]
  root to: "users#index"
end
