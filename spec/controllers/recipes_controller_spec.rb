require 'rails_helper'

RSpec.describe RecipesController, type: :controller do
  before(:each) do
    # Create test data using FactoryBot
    @recipe1 = FactoryBot.create(:recipe, :author, :category)
    @recipe2 = FactoryBot.create(:recipe, :author, :category)
  end

  describe 'GET #index' do
    it 'renders the HTML index view' do
      get :index
      expect(response).to render_template('index')
      expect(response.content_type).to eq 'text/html; charset=utf-8'
    end

    it 'renders JSON with status 200 when query parameter is present' do
      get :index, params: { query: 'some_query' }, format: :json
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq 'application/json; charset=utf-8'
      expect(response.parsed_body).to eq []
    end

    it 'renders JSON with status 200 when query parameter is not present' do
      get :index, format: :json
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq 'application/json; charset=utf-8'
      expect(response.parsed_body).not_to eq []
    end

    it 'returns valid data from the database in JSON format' do
      get :index, format: :json
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq 'application/json; charset=utf-8'

      parsed_response = response.parsed_body
      expect(parsed_response.count).to eq(2)

      expect(parsed_response[0]['title']).to eq(@recipe1.title)
      expect(parsed_response[1]['title']).to eq(@recipe2.title)
    end
  end

  describe 'POST #favorite' do
    let(:user) { create(:user) }
    let(:recipe) { create(:recipe, :author, :category) }

    before { sign_in user }

    context 'when the recipe is favorited by the user' do
      before do
        post :favorite, params: { id: recipe.id }
      end

      it 'adds the recipe to user favorites' do
        expect(user.favorite_recipes).to include(recipe)
      end

      it 'returns a success JSON response' do
        expect(response).to have_http_status(:success)
        expect(response.parsed_body['favorited']).to eq(true)
      end
    end

    context 'when the recipe is unfavorited by the user' do
      before do
        user.favorite_recipes << recipe
        post :favorite, params: { id: recipe.id }
      end

      it 'removes the recipe from user favorites' do
        expect(user.favorite_recipes).not_to include(recipe)
      end

      it 'returns a success JSON response' do
        expect(response).to have_http_status(:success)
        expect(response.parsed_body['favorited']).to eq(false)
      end
    end
  end
end
