require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe 'pg_search_scope' do
    it 'searches by title and ingredients' do
      recipe = FactoryBot.create(:recipe, :author, :category, title: 'Delicious Dish')
      FactoryBot.create(:ingredient, recipe:, description: 'Onion')

      expect(Recipe.search_by_title_and_ingredients('Delicious Dish')).to include(recipe)
      expect(Recipe.search_by_title_and_ingredients('Onion')).to include(recipe)
    end
  end
end
