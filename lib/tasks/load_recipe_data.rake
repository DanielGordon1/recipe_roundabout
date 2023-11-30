# lib/tasks/recipe_parser.rake

task :parse_recipes => :environment do
  parser = RecipeParser.new(Rails.root.join('tmp/data/tests/recipes.json'))
  parser.parse_and_insert_efficiently
end
