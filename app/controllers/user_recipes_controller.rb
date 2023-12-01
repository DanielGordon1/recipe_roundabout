class UserRecipesController < ApplicationController
  before_action :authenticate_user! # Ensure the user is authenticated to view favorite recipes

  def index
    @favorite_recipes = current_user.favorite_recipes.includes(:ingredients).as_json(include: :ingredients)
  end
end
