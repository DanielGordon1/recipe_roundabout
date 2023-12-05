class UserRecipesController < ApplicationController
  before_action :authenticate_user! # Ensure the user is authenticated to view favorite recipes

  def index
    @favorite_recipes = current_user.favorite_recipes.includes(:ingredients).as_json(include: :ingredients)
    @favorite_recipes.map! do |recipe|
      recipe['is_favorited'] = true
      recipe
    end
    @favorite_recipe_ids = @current_user.favorite_recipes.map(&:id)
    # BELOW IS WIP
    # Get new recipe suggestions from ChatGPTService
    # @chat_gpt_recipes = ChatGPTService.get_new_recipe_suggestions(
    #   recipe_titles: @favorite_recipes.map(&:title),
    #   ingredients: @favorite_recipes.map(&:ingredients)
    # )
  end
end
