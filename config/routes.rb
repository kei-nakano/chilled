Rails.application.routes.draw do
  root 'home#top'
  get 'about' => 'home#about'
  get 'login' => 'users#login_form'
  post 'login' => 'users#login'
  post 'logout' => 'users#logout'
  post 'likes/:item_id/create' => 'likes#create'
  post 'likes/:item_id/destroy' => 'likes#destroy'
  get 'users/:id/likes' => 'users#likes'
  resources :items
  resources :users
end
