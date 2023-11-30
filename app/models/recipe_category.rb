class RecipeCategory < ApplicationRecord
  has_many :recipes, inverse_of: :category, dependent: :destroy
end
