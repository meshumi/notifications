Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users, path: 'auth', path_names: {
    sign_in:      'login',
    sign_out:     'logout'
  }

  post :notification, controller: :notifications, action: :create
  root 'home#index'

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :notification_receivers, only: :create
    end
  end
end
