require 'rails_helper'

RSpec.describe RecipeSearchService, type: :service do
  before do
    # Create test data using FactoryBot
    @recipe = FactoryBot.create(:recipe, :author, :category, title: 'Crab Cakes')
    FactoryBot.create(:ingredient, recipe: @recipe, description: 'Crab')

    @recipe2 = FactoryBot.create(:recipe, :author, :category, title: 'Banana Biscuit')
    FactoryBot.create(:ingredient, recipe: @recipe2, description: 'Flour')
  end
  describe '#search' do
    context 'when searching for recipes' do
      it 'returns relevant recipes based on the search query' do
        expect(RecipeSearchService.search('Crab Cakes')).to include(@recipe)
        expect(RecipeSearchService.search('crab')).to include(@recipe)
        expect(RecipeSearchService.search('Crab')).not_to include(@recipe2)
        expect(RecipeSearchService.search('Flour')).to include(@recipe2)
      end
    end
  end
end
