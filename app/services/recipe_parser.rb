class RecipeParser
  SUPPORTED_FORMATS = %w[json].freeze
  BATCH_SIZE = ENV["BATCH_SIZE"] || 100

  def initialize(file_path)
    @file_path = file_path
    extension = file_extension(file_path)

    validate_extension(extension)

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
    @categories = RecipeCategory.all.to_a
    @authors = User.all.to_a

    # Batch Process data
    batch_size = BATCH_SIZE # Adjust the batch size based on the dataset and system capacity

    recipes.each_slice(batch_size).flat_map do |recipe_batch|
      recipe_ingredients = []
      recipe_batch.map! do |recipe_data|
        # Store ingredients in an array
        recipe_ingredients << recipe_data['ingredients'].map { |ingredient| { description: ingredient } }
        build_recipe(recipe_data)
      end
      # Insert and upsert skip AR validations and callbacks.
      # Which is not necesarrily what we want, but these methods do provide a straightforward way to batch insert / update records.
      # Luckily we have some DB level constraints. :-)
      saved_recipes = Recipe.upsert_all(recipe_batch, :index_recipes_on_title_and_image_url)
      saved_recipe_ids = saved_recipes.pluck('id')

      # Associate ingredients with saved recipes
      ingredients = []
      recipe_ingredients.each_with_index do |recipe_ingredient_array, index|
        recipe_ingredient_array.each do |ingredient|
          ingredients << { recipe_id: saved_recipe_ids[index], description: ingredient[:description] }
        end
      end
      Ingredient.upsert_all(ingredients, unique_by: [:index_ingredients_on_recipe_id_and_description])
    end
  end

  private

  def build_recipe(recipe_data)
    {
      title: recipe_data['title'],
      cooking_time_minutes: recipe_data['cook_time'],
      preparation_time_minutes: recipe_data['prep_time'],
      rating: recipe_data['ratings'],
      cuisine: recipe_data['cuisine'],
      recipe_category_id: @categories.find { |category| category.name == recipe_data['category'] }&.id,
      user_id: @authors.find { |author| author.username == recipe_data['author'] }&.id,
      image_url: recipe_data['image']
    }
  end

  def validate_extension(extension)
    return if SUPPORTED_FORMATS.include?(extension)

    raise ArgumentError,
          "Unsupported file format: .#{extension}. Only #{SUPPORTED_FORMATS.join(', ')} files are supported."
  end
end
