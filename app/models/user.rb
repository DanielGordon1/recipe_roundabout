class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :recipes, inverse_of: :author, dependent: :destroy
  has_many :users_recipes, dependent: :destroy
  has_many :favorited_recipes, through: :users_recipes, source: :recipe
end
