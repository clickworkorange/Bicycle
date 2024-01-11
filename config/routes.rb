Rails.application.routes.draw do

  resources :pages

  devise_for :users

  root "pages#index"
  get "pages/index"

namespace :helm do
  root "pages#index"
  resources :pages #, except: [:show]
  resources :users #, except: [:show]
  #resources :uploads, only: [:index, :show, :update, :create]
  #resources :settings, only: [:index, :edit, :update]
end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  #get "up" => "rails/health#show", as: :rails_health_check
end
