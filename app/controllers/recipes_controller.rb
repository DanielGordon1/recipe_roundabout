class RecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    if params[:query].present?
      # TODO: Should probably paginate this.
      @recipes = Recipe.includes(:ingredients).search_by_title_and_ingredients(params[:query]).limit(50)
    else
      @recipes = Recipe.includes(:ingredients).order("RANDOM()").limit(10).as_json(include: :ingredients)
    end
    @current_user = current_user

    respond_to do |format|
      format.html { render 'index' }
      format.json { render json: @recipes.to_json(include: :ingredients), status: :ok }
    end
  end

  def favorite
    @recipe = Recipe.find(params[:id])
    if current_user.favorite_recipes.include?(@recipe)
      current_user.users_recipes.find_by(recipe_id: @recipe.id).destroy
    else
      current_user.users_recipes.create(recipe_id: @recipe.id)
    end
    render json: { favorited: current_user.favorite_recipes.include?(@recipe) }
  end
end
