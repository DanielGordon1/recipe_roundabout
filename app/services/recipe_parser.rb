class RecipeParser
  SUPPORTED_FORMATS = %w[json].freeze

  def initialize(file_path)
    @file_path = file_path
    extension = file_extension(file_path)

    unless SUPPORTED_FORMATS.include?(extension)
      raise ArgumentError,
            "Unsupported file format: .#{extension}. Only #{SUPPORTED_FORMATS.join(', ')} files are supported."
    end

    case extension
    when 'json'
      @json_data = File.read(file_path)
    else
      raise ArgumentError, "Unsupported file format: .#{extension}."
    end
  end

  def file_extension(file_path)
    File.extname(file_path).delete('.')
  end

  def parse_and_insert_efficiently
    recipes = JSON.parse(@json_data)
    # Preload data
    categories = RecipeCategory.all.to_a
    authors = User.all.to_a

    # Batch Process data
    batch_size = 100 # Adjust the batch size based on the dataset and system capacity

    recipes.each_slice(batch_size).flat_map do |recipe_batch|
      recipe_ingredients = []
      recipe_batch.map! do |recipe_data|
        # ingredients = recipe_data["ingredients"].map { |ingredient| { description: ingredient }})
        # Store ingredients in an array
        recipe_ingredients << recipe_data['ingredients'].map { |ingredient| { description: ingredient } }
        {
          title: recipe_data['title'],
          cooking_time_minutes: recipe_data['cook_time'],
          preparation_time_minutes: recipe_data['prep_time'],
          rating: recipe_data['ratings'],
          cuisine: recipe_data['cuisine'],
          recipe_category_id: categories.find { |category| category.name == recipe_data['category'] }&.id,
          user_id: authors.find { |author| author.username == recipe_data['author'] }&.id, 
          image_url: recipe_data['image']
        }
      end
      # Insert and upsert skip AR validations and callbacks.
      # Luckily we have "some" DB level constraints.
      saved_recipes = Recipe.insert_all(recipe_batch)
      saved_recipe_ids = saved_recipes.pluck('id')

      # Associate ingredients with saved recipes
      ingredients = []
      recipe_ingredients.each_with_index do |recipe_ingredient_array, index|
        recipe_ingredient_array.each do |ingredient|
          ingredients << { recipe_id: saved_recipe_ids[index], description: ingredient[:description] }
        end
      end
      Ingredient.upsert_all(ingredients)
    end
  end
end
