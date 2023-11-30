task parse_recipes: :environment do
  puts "Parsing"
  parser = RecipeParser.new(Rails.root.join('tmp/data/tests/recipes.json'))
  parser.parse_and_insert_efficiently
end
