Rails.application.routes.draw do
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'
  get '/logout', to: 'sessions#destroy'
  get '/users', to: 'users#index'
  root to: "tweets#index"
  resources :tweets, only: [:new, :show] do
    member do
      post "post_create"
    end
    collection do
      post "search"
      post "retweet"
    end
  end
end