# spec/factories/recipes.rb
FactoryBot.define do
  let(:random_string) {
    "author_#{rand(1...100)}"
  }
  factory :user do
    username { random_string }
    email { "#{random_string}@email.com" }
    password { SecureRandom.hex(10) }
  end
end
