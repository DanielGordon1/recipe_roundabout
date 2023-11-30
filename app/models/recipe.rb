class Recipe < ApplicationRecord
  include PgSearch::Model
  belongs_to :author, class_name: 'User', foreign_key: 'user_id', inverse_of: :recipes
  belongs_to :category, class_name: 'RecipeCategory', foreign_key: :recipe_category_id, inverse_of: :recipes
  has_many :ingredients, dependent: :destroy
  pg_search_scope :search_by_title_and_ingredients,
                  against: {
                    title: 'A' # Assuming 'title' is a column in the 'recipes' table
                  },
                  associated_against: {
                    ingredients: [:description] # Adjust 'name' to the attribute in your Ingredient model
                  },
                  using: {
                    tsearch: { prefix: true }
                  }
end
