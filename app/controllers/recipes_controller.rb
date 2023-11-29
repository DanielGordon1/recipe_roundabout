class RecipesController < ApplicationController
    skip_before_action :authenticate_user!, only: [:index]

    def index
      query = params[:query]
      recipes = RecipeSearchService.search(query)
      render json: recipes, status: :ok
    end
  end
