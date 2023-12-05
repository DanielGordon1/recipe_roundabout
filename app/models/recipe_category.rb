class RecipeCategory < ApplicationRecord
  validates :name, presence: true
  has_many :recipes, inverse_of: :category, dependent: :destroy
end
