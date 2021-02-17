Rails.application.routes.draw do
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'
  get '/logout', to: 'sessions#destroy'
  get '/users', to: 'users#index'
  get '/auto_tweet', to: 'tweets#auto_tweet'
  root to: "tweets#index"
  resources :tweets, only: [:new, :show] do
    collection do
      post "search"
      post "retweet"
      post "repost"
    end
  end
end