require 'rails_helper'

RSpec.describe RecipeParser do
  let(:valid_json) { '[{"title":"Test Recipe","cook_time":30,"prep_time":15,"ingredients":["Ingredient 1","Ingredient 2"],"ratings":4.5,"cuisine":"Italian","category":"Pasta","author":"John Doe","image":"https://example.com/image.jpg"}]' }
  let(:invalid_json) { 'invalid json data' }

  describe '#initialize' do
    context 'with unsupported file format' do
      it 'raises an ArgumentError' do
        expect { RecipeParser.new('recipe.txt') }.to raise_error(ArgumentError, "Unsupported file format: .txt. Only json files are supported.")
      end
    end

    context 'with supported file format' do
      it 'initializes without raising an error for JSON file' do
        expect { RecipeParser.new('recipes.json') }.not_to raise_error
      end
    end
  end

  describe '#parse_and_insert_efficiently' do
    before do
      allow(RecipeCategory).to receive(:all).and_return([RecipeCategory.new(name: 'Pasta')])
      allow(User).to receive(:all).and_return([User.new(name: 'John Doe')])
    end

    context 'with valid JSON data' do
      it 'inserts recipes efficiently' do
        allow(File).to receive(:read).and_return(valid_json)
        expect(Recipe).to receive(:insert_all).with([
          {
            title: 'Test Recipe',
            cooking_time_minutes: 30,
            preparation_time_minutes: 15,
            ingredients: ['Ingredient 1', 'Ingredient 2'],
            rating: 4.5,
            cuisine: 'Italian',
            category: instance_of(RecipeCategory),
            author: instance_of(User),
            image: 'https://example.com/image.jpg'
          }
        ]).once
        RecipeParser.parse_and_insert_efficiently('recipes.json')
      end
    end

    context 'with invalid JSON data' do
      it 'raises an error when JSON is malformed' do
        allow(File).to receive(:read).and_return(invalid_json)
        expect { RecipeParser.parse_and_insert_efficiently('invalid_recipes.json') }.to raise_error(JSON::ParserError)
      end
    end
  end
end
