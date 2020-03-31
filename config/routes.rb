Rails.application.routes.draw do
  devise_for :users
  resources :bugs
  resources :comments
  root 'bugs#index'
end
