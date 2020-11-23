Rails.application.routes.draw do
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/tweets', to: 'tweets#index'
  root to: "users#index"
end
