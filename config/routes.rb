Rails.application.routes.draw do
  
  devise_for :users

  namespace :bicycle do
    root "pages#index"
    resources :pages, only: [:index, :new, :create, :edit, :update, :destroy] do
      post "move"
      post "toggle"
      resources :images, only: [:new, :create, :edit, :update, :destroy]
    end
    resources :users
  end

  # TODO: surely there's a better way? 
  resources :pages, only: :show, path: "" do
    resources :images, only: :show
    resources :pages, only: :show, path: "" do
      resources :images, only: :show
      resources :pages, only: :show, path: "" do
        resources :images, only: :show
      end
    end
  end
  
  root "pages#index"
  #get ":custom_url", to: "pages#show"
end
