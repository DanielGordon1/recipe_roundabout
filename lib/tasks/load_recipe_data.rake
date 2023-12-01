task parse_recipes: :environment do
  puts "Parsing"
  parser = RecipeParser.new(Rails.root.join('storage/data/recipes-en.json'))
  parser.parse_and_insert_efficiently
end
