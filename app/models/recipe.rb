class Recipe < ApplicationRecord
  include PgSearch::Model
  attr_accessor :is_favorited

  belongs_to :author, class_name: 'User', foreign_key: 'user_id', inverse_of: :recipes
  belongs_to :category, class_name: 'RecipeCategory', foreign_key: :recipe_category_id, inverse_of: :recipes

  has_many :ingredients, dependent: :destroy
  has_many :users_recipes, dependent: :destroy
  has_many :favorite_recipes, through: :users_recipes, source: :user

  validates :title, :rating, presence: true
  validates :title, uniqueness: { scope: :image_url }

  # Research weighting 
  # query: Pita Bread / Pita Bread Steak
  pg_search_scope :search_by_title_and_ingredients,
                  against: { title: "A" },
                  associated_against: {
                    ingredients: {
                      description: 'B'
                    }
                  },
                  using: {
                    tsearch: { prefix: true }
                  }
end
