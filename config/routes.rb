Rails.application.routes.draw do
  root 'home#top'
  get 'search' => 'search#show', as: 'search'
  get 'about' => 'home#about'
  get 'login' => 'users#login_form'
  post 'login' => 'users#login'
  post 'logout' => 'users#logout'
  post 'likes/:item_id/create' => 'likes#create'
  post 'likes/:item_id/destroy' => 'likes#destroy'
  post 'comment_likes/:comment_id' => 'comment_likes#create', as: 'comment_like_create'
  delete 'comment_likes/:comment_id' => 'comment_likes#destroy', as: 'comment_like_destroy'
  post 'review_likes/:review_id' => 'review_likes#create', as: 'review_like_create'
  delete 'review_likes/:review_id' => 'review_likes#destroy', as: 'review_like_destroy'
  get 'users/:id/likes' => 'users#likes'
  get 'users/:id/timeline' => 'users#timeline'
  post 'relationships/:followed_id/create' => 'relationships#create'
  delete 'relationships/:followed_id/destroy' => 'relationships#destroy'
  get 'comments/:review_id/new' => 'comments#new'
  post 'comments/:review_id/create' => 'comments#create'
  delete 'comments/:id' => 'comments#destroy', as: 'comment'
  get 'comments/:id' => 'comments#edit'
  patch 'comments/:id' => 'comments#update'
  resources :items
  resources :users do
    member do
      get :following, :followers
    end
  end
end
