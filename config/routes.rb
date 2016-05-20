Rails.application.routes.draw do
  apipie
  root to: 'visitors#index'
  devise_for :users
  resources :users

  resources :albums do
    resources :pictures 
  end
  
  namespace :api, :defaults => { :format => 'json' } do
    namespace :v1 do
      resources :users, :only => [:index, :show, :update, :destroy]

      resource :registration, :only => [:create]

      resource :session, only: [:create, :destroy]

      resources :albums do
        resources :pictures
      end
    end
  end
end
