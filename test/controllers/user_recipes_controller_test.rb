require 'rails_helper'

RSpec.describe UserRecipesController, type: :controller do
  describe 'GET #index' do
    context 'when user is authenticated' do
      let(:user) { create(:user) }
      let(:recipes) { create_list(:recipe, 5) }

      before do
        sign_in user
        user.favorite_recipes << recipes
        get :index
      end

      it 'responds successfully' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end

      it 'assigns @favorite_recipes' do
        expect(assigns(:favorite_recipes)).not_to be_nil
        expect(assigns(:favorite_recipes)).to match_array(recipes)
      end

      it 'assigns @favorite_recipe_ids' do
        expect(assigns(:favorite_recipe_ids)).not_to be_nil
        expect(assigns(:favorite_recipe_ids)).to match_array(recipes.pluck(:id))
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to sign in page' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
