# spec/factories/recipes.rb
FactoryBot.define do
  factory :user do
    username { "author_#{rand(1...100)}" }
    email { "author_#{rand(1...10_000)}@email.com" }
    password { SecureRandom.hex(10) }
  end
end
