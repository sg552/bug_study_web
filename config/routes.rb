Rails.application.routes.draw do
  devise_for :users
  resources :bugs
  resources :comments
  root 'bugs#index'
  namespace :api do
    resources :bugs do
      post :update_comment
    end
  end
end
