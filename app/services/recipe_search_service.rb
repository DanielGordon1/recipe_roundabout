# app/services/recipe_search_service.rb

class RecipeSearchService
    def self.search(query)
      if query.present?
        Recipe.search_by_title_and_ingredients(query)
      else
        Recipe.all
      end
    end
  end
  