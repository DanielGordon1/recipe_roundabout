# spec/factories/recipes.rb
FactoryBot.define do
  factory :recipe_category do
    name { ["Bread", "Pastry", "Curry", "Soup"].sample }
  end
end
