class Recipe < ApplicationRecord
  include PgSearch::Model
  belongs_to :user
  belongs_to :category
  has_many :ingredients
  pg_search_scope :search_by_title_and_ingredients,
                  against: {
                    title: 'A',
                    ingredients: 'B' # Replace 'ingredients' with the appropriate association name
                  },
                  using: {
                    tsearch: { any_word: true }
                  }
end
