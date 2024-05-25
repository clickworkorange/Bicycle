Rails.application.routes.draw do
  devise_for :users, module: "users", path: "user"
  devise_scope :user do
    get "user", to: "users/registrations#show", as: nil
  end

  namespace :bicycle do
    root "pages#index"
    resources :comments, only: %i[index destroy]
    resources :pages, only: %i[index new create edit update destroy] do
      post "move"
      resources :images, only: %i[new create edit update destroy]
    end
    resources :users
    get "statistics", to: "statistics#index"
    get "images/regenerate(/:job_id)", to: "images#regenerate"
    post "images/regenerate", to: "images#regenerate"
  end

  root "pages#index"
  # post "(*path)/:id/comments", to: "comments#create", as: :page_comments
  post "(*path)/:id", to: "pages#comment", as: :page_comments
  get "(*path)/:id", to: "pages#show", as: :page
end
