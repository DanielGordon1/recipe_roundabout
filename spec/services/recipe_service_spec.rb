require 'rails_helper'

RSpec.describe RecipeParser do
  let(:invalid_json) { 'invalid json data' }
  let(:valid_path) { Rails.root.join('tmp/data/tests/recipes.json').to_s }

  describe '#initialize' do
    context 'with unsupported file format' do
      it 'raises an ArgumentError' do
        expect do
          RecipeParser.new('recipe.txt')
        end.to raise_error(ArgumentError,
                           "Unsupported file format: .txt. Only json files are supported.")
      end
    end

    context 'with supported file format' do
      it 'initializes without raising an error for JSON file' do
        expect { RecipeParser.new(valid_path) }.not_to raise_error
      end
    end
  end

  describe '#parse_and_insert_efficiently' do
    before do
      RecipeCategory.create(name: 'Pasta')
      User.create(username: 'John Doe')
    end

    context 'with valid JSON data' do
      it 'inserts recipes and ingredients efficiently' do
        expect do
          RecipeParser.new(valid_path).parse_and_insert_efficiently
        end.to change(Recipe, :count).by(2)
        expect do
          RecipeParser.new(valid_path).parse_and_insert_efficiently
        end.to change(Ingredient, :count).by(6)
      end

      context 'with invalid JSON data' do
        it 'raises an error when JSON is malformed' do
          allow(File).to receive(:read).and_return(invalid_json)
          expect do
            RecipeParser.new(valid_path).parse_and_insert_efficiently
          end.to raise_error(JSON::ParserError)
        end
      end
    end
  end
end
