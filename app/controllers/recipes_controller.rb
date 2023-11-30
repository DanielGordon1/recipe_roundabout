class RecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    if params[:query].present?
      # TODO: Should probably paginate this.
      @recipes = Recipe.includes(:ingredients).search_by_title_and_ingredients(params[:query])
    else
      @recipes = Recipe.includes(:ingredients).order("RANDOM()").limit(10)
    end

    respond_to do |format|
      format.html { render 'index' }
      format.json { render json: @recipes, status: :ok }
    end
  end
end
