# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
puts "Destroying all data..."
UsersRecipe.delete_all
User.delete_all
RecipeCategory.delete_all
Ingredient.delete_all
Recipe.delete_all
puts "Creating Recipes"
RecipeParser.new(Rails.root.join('tmp/data/recipes-en.json').to_s).parse_and_insert_efficiently
