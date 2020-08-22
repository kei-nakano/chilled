Rails.application.routes.draw do
  get '/' => 'home#top', as: 'root'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  post 'logout' => 'sessions#destroy'
  get 'search' => 'search#show', as: 'search'
  resources :items, except: %i[index]
  resources :reviews, except: %i[index show]
  resources :manufacturers, only: %i[edit update destroy]
  resources :categories, only: %i[edit update destroy]
  resources :tags, only: %i[destroy]
  resources :comments, except: %i[index]
  resources :rooms, only: %i[index show create]
  resources :notices, only: %i[index destroy]
  resources :relationships, only: %i[create destroy]
  resources :blocks, only: %i[create destroy]
  resources :comment_likes, only: %i[create destroy]
  resources :review_likes, only: %i[create destroy]
  resources :eaten_items, only: %i[create destroy]
  resources :want_to_eat_items, only: %i[create destroy]
  resources :users, except: %i[index]
  resources :account_activations, only: [:edit]
  resources :password_resets, only: %i[new create edit update]
  resources :hidden_rooms, only: %i[create]

  # Linebot開発テスト用
  post '/callback' => 'linebot#callback'
end
