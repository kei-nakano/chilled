Rails.application.routes.draw do
  root 'home#top'
  get 'about' => 'home#about'
  get 'login' => 'users#login_form'
  post 'login' => 'users#login'
  post 'logout' => 'users#logout'
  post 'likes/:item_id/create' => 'likes#create'
  post 'likes/:item_id/destroy' => 'likes#destroy'
  get 'users/:id/likes' => 'users#likes'
  get 'users/:id/timeline' => 'users#timeline'
  post 'relationships/:followed_id/create' => 'relationships#create'
  delete 'relationships/:followed_id/destroy' => 'relationships#destroy'
  get 'comments/:review_id/new' => 'comments#new'
  post 'comments/:review_id/create' => 'comments#create'
  delete 'comments/:review_id/destroy' => 'comments#destroy'
  resources :items
  resources :users do
    member do
      get :following, :followers
    end
  end
  # resources :relationships, only: %i[create destroy]
end
