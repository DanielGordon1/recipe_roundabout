class UserRecipesController < ApplicationController
  before_action :authenticate_user! # Ensure the user is authenticated to view favorite recipes

  def index
    @favorite_recipes = current_user.favorite_recipes.includes(:ingredients).as_json(include: :ingredients)
    @favorite_recipes.map! do |recipe|
      recipe['is_favorited'] = true
      recipe
    end
    @favorite_recipe_ids = @current_user.favorite_recipes.map(&:id)
    return unless @favorite_recipes.any? && Flipper.enabled?(:chat_gpt_recommendations, current_user)

    # BELOW IS WIP
    # Get new recipe suggestions from ChatGPTService
    @chat_gpt_recipes = chat_gpt_recipe_recommendations
  end

  private

  def chat_gpt_recipe_recommendations
    ChatGptService.new(
      recipe_titles: @favorite_recipes.pluck("title"),
      ingredients: @favorite_recipes.pluck("ingredients").flatten.pluck("description")
    ).new_recipe_suggestions
  end
end
