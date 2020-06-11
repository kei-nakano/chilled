Rails.application.routes.draw do
  root 'home#top'
  get 'search' => 'search#show', as: 'search'
  get 'about' => 'home#about'
  get 'login' => 'users#login_form'
  post 'login' => 'users#login'
  post 'logout' => 'users#logout'
  post 'comment_likes/:comment_id' => 'comment_likes#create', as: 'comment_like_create'
  delete 'comment_likes/:comment_id' => 'comment_likes#destroy', as: 'comment_like_destroy'
  post 'review_likes/:review_id' => 'review_likes#create', as: 'review_like_create'
  delete 'review_likes/:review_id' => 'review_likes#destroy', as: 'review_like_destroy'
  post 'eaten_items/:item_id' => 'eaten_items#create', as: 'eaten_item_create'
  delete 'eaten_items/:item_id' => 'eaten_items#destroy', as: 'eaten_item_destroy'
  post 'want_to_eat_items/:item_id' => 'want_to_eat_items#create', as: 'want_to_eat_item_create'
  delete 'want_to_eat_items/:item_id' => 'want_to_eat_items#destroy', as: 'want_to_eat_item_destroy'
  get 'users/:id/timeline' => 'users#timeline'
  post 'relationships/:followed_id/create' => 'relationships#create'
  delete 'relationships/:followed_id/destroy' => 'relationships#destroy'
  get 'comments/:review_id/new' => 'comments#new'
  post 'comments/:review_id/create' => 'comments#create'
  delete 'comments/:id' => 'comments#destroy', as: 'comment'
  get 'comments/:id' => 'comments#edit'
  patch 'comments/:id' => 'comments#update'
  get 'users/:user_id/room/:room_id' => 'rooms#show'
  get 'rooms/index' => 'rooms#index'
  post 'rooms/create' => 'rooms#create', as: 'room_create'
  resources :items
  resources :notices, only: %i[index]
  resources :users do
    member do
      get :following, :followers
    end
  end
end
