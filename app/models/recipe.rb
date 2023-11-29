class Recipe < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :ingredients
end
