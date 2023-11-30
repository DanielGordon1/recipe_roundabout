Rails.application.routes.draw do
  devise_for :users
  root to: "recipes#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :recipes, only: [:index]
  # Defines the root path route ("/")
  # root "articles#index"
end
