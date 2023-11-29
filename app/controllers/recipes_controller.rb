class RecipesController < ApplicationController
    def index
      query = params[:query]
      recipes = RecipeSearchService.search(query)
      render json: recipes, status: :ok
    end
  end
