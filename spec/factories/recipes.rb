# spec/factories/recipes.rb
FactoryBot.define do
  factory :recipe do
    author
    title { 'Sample Recipe' }
    cooking_time_minutes { 30 }
    preparation_time_minutes { 30 }
    rating { rand(1...5) }
    image_url { "https://sallysbakingaddiction.com/wp-content/uploads/2018/10/homemade-banana-bread.jpg" }
    cuisine { "French" }
  end
end
