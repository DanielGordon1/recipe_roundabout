# spec/factories/recipes.rb
FactoryBot.define do
  factory :recipe do
    title { 'Sample Recipe' }
    cooking_time_minutes { rand(1...120) }
    preparation_time_minutes { rand(1...50) }
    rating { rand(1...5) }
    image_url { "https://sallysbakingaddiction.com/wp-content/uploads/2018/10/homemade-banana-bread.jpg" }
    cuisine { "French" }
    trait :category do
      association :category, factory: :recipe_category
    end

    trait :author do
      association :author, factory: :user
    end
  end
end
