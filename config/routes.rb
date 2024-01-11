Rails.application.routes.draw do
  resources :images

  resources :pages do
    resources :images
  end

  devise_for :users

  root "pages#index"
  get "pages/index"

  namespace :helm do
    root "pages#index"
    resources :pages do
      resources :images
    end
    resources :users
  end
end
