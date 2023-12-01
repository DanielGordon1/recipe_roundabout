class UserRecipesController < ApplicationController
  before_action :authenticate_user! # Ensure the user is authenticated to view favorite recipes

  def index
    @favorite_recipes = current_user.favorite_recipes.includes(:ingredients).as_json(include: :ingredients)

    # ingredients = @favorite_recipes.ingredients.map(&:description) # Assuming the user has ingredients associated
    # Get new recipe suggestions from ChatGPTService
    # new_suggestions = ChatGPTService.get_new_recipe_suggestions(favorite_recipes, ingredients)

    # Further processing or rendering based on new_suggestions
    # For example:
    # render json: { new_suggestions: new_suggestions }, status: :ok
  end
end
