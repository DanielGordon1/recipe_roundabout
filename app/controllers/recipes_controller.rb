class RecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    if params[:query].present?
      @recipes = RecipeSearchService.search(params[:query]).as_json(include: :ingredients)
    else
      @recipes = Recipe.includes(:ingredients).order("RANDOM()").limit(10).as_json(include: :ingredients)
    end
    set_favorite_on_recipes

    respond_to do |format|
      format.html { render 'index' }
      format.json { render json: @recipes, status: :ok }
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

  private

  def set_favorite_on_recipes
    # Could use a join instead of setting this in memory.
    # Alternatively use a hash lookup which is faster than an array includes
    favorite_recipe_hash = {}
    @current_user&.favorite_recipes&.map { |recipe| favorite_recipe_hash[recipe.id] = recipe }
    @favorite_recipe_ids = favorite_recipe_hash.keys
    return if favorite_recipe_hash.empty?

    @recipes.map! do |recipe|
      recipe['is_favorited'] = true if favorite_recipe_hash.key?(recipe['id'])
      recipe
    end
  end
end
