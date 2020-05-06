Rails.application.routes.draw do
  root 'home#top'
  get 'about' => 'home#about'
  resources :items
  resources :users
end
