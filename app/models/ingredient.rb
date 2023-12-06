class Ingredient < ApplicationRecord
  belongs_to :recipe
  validates :description, presence: true
  validates :description, uniqueness: { scope: :recipe_id }
  
end
