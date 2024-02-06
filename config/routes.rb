Rails.application.routes.draw do
  devise_for :users

  namespace :bicycle do
    root "pages#index"
    get "images/regenerate(/:job_id)", to: "images#regenerate"
    post "images/regenerate", to: "images#regenerate"
    resources :pages, only: %i[index new create edit update destroy] do
      post "move"
      # post "toggle"
      resources :images, only: %i[new create edit update destroy]
    end
    resources :users
  end

  # # TODO: surely there's a better way?
  # resources :pages, only: :show, path: "" do
  #   resources :comment, only:  %i[create update destroy]
  #   # resources :images, only: :show
  #   resources :pages, only: :show, path: "" do
  #     resources :comment, only:  %i[create update destroy]
  #     # resources :images, only: :show
  #     resources :pages, only: :show, path: "" do
  #       resources :comment, only:  %i[create update destroy]
  #       # resources :images, only: :show
  #     end
  #   end
  # end

  root "pages#index"
  # get "images/:id", to: "images#show"
  scope "*path" do
    get "*id", to: "pages#show"
    resources :comments, only:  %i[create update destroy], as: :page_comments
  end
  get "(*path)/:id", to: "pages#show", as: :page
  
end
