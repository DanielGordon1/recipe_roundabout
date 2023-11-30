# spec/factories/recipes.rb
FactoryBot.define do
  factory :ingredient do
    description { ['Butter', 'Banana', 'Salt', 'Flour'].sample }
  end
end
