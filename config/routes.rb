Rails.application.routes.draw do
  devise_for :users
  resources :bugs
  root 'bugs#index'
end
