Rails.application.routes.draw do
  root 'home#top'
  get 'about' => 'home#about'
  get 'items/index' => 'items#index'
end
