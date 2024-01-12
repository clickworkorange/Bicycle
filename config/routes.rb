Rails.application.routes.draw do
  
  devise_for :users

  namespace :helm do
    root "pages#index"
    resources :pages do
      resources :images
    end
    resources :users
  end

  resources :pages, only: :show, path: "" do
    resources :images, only: :show
  end

  root "pages#index"
  get "pages/index"

end
