Rails.application.routes.draw do
  devise_for :users
  resources :bugs
  resources :comments
  root 'bugs#index'
  namespace :api do
    resources :bugs do
      collection do
        post :update_comment
        get :bookmarks
        post :update_bookmark
      end
    end
  end
end
