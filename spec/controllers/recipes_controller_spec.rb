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
end
