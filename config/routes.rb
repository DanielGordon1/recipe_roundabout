Rails.application.routes.draw do
  devise_for :users
  root to: "recipes#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :recipes, only: [:index] do
    member do
      post 'favorite'
    end
  end

  resource :user do
    member do
      get "favorite_recipes", to: "user_recipes#index"
    end
  end
end
