Rails.application.routes.draw do
  get '/' => 'home#top', as: 'root'
  get 'search' => 'search#show', as: 'search'
  get 'login' => 'users#login_form'
  post 'login' => 'users#login'
  post 'logout' => 'users#logout'
  get 'users/:id/timeline' => 'users#timeline'
  get 'comments/:review_id/new' => 'comments#new'
  post 'comments/:review_id/create' => 'comments#create'
  delete 'comments/:id' => 'comments#destroy', as: 'comment'
  get 'comments/:id' => 'comments#edit'
  patch 'comments/:id' => 'comments#update'
  delete 'notices' => 'notices#destroy'
  resources :items, except: %i[index]
  resources :reviews
  resources :rooms, only: %i[index show create]
  resources :notices, only: %i[index]
  resources :relationships, only: %i[create destroy]
  resources :blocks, only: %i[create destroy]
  resources :comment_likes, only: %i[create destroy]
  resources :review_likes, only: %i[create destroy]
  resources :eaten_items, only: %i[create destroy]
  resources :want_to_eat_items, only: %i[create destroy]
  resources :users, except: %i[index]
end
