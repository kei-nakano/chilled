Rails.application.routes.draw do
  root 'home#top'
  get 'about' => 'home#about'
  get 'login' => 'users#login_form'
  post 'login' => 'users#login'
  post 'logout' => 'users#logout'
  resources :items
  resources :users
end
