Rails.application.routes.draw do
  root 'home#top'
  get 'about' => 'home#about'
  # get 'items/index' => 'items#index'
  # get 'items/:id' => 'items#show'
  # get 'items/new' => 'items#new'
  # post 'items' => 'items#create'
  # get 'items/:id/edit' => "items#edit"
  # patch 'items/:id' => 'item#update'
  # delete 'items/:id' => 'item#destroy'
  resources :items
end
