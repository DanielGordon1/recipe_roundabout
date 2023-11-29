class RecipeParser
    
    SUPPORTED_FORMATS = %w[json].freeze
    
    def initialize(file_path)
        @file_path = file_path
        extension = file_extension(file_path)
        
        unless SUPPORTED_FORMATS.include?(extension)
            raise ArgumentError, "Unsupported file format: .#{extension}. Only #{SUPPORTED_FORMATS.join(', ')} files are supported."
        end
        
        case extension
        when 'json'
            @json_data = File.read(file_path)
        else
            raise ArgumentError, "Unsupported file format: .#{extension}."
        end
    end
    
    def self.file_extension(file_path)
        File.extname(file_path).delete('.')
    end
    
    def self.parse_and_insert_efficiently(file_path)
        recipes = JSON.parse(@json_data)
        # Preload data
        categories = RecipeCategory.all.to_a
        authors = User.all.to_a
        
        # Batch Process data
        batch_size = 100 # Adjust the batch size based on the dataset and system capacity
        recipes.each_slice(batch_size).flat_map do |recipe_batch|
            recipe_batch.map do |recipe_data|
                {
                    title: recipe_data['title'],
                    cooking_time_minutes: recipe_data['cook_time'],
                    preparation_time_minutes: recipe_data['prep_time'],
                    ingredients: recipe_data['ingredients'],
                    rating: recipe_data['ratings'],
                    cuisine: recipe_data['cuisine'],
                    category: categories.find { |category| category.name == recipe_data['category'] },
                    author: authors.find { |author| author.name == recipe_data['author'] },
                    image: recipe_data['image']
                }
                # This skips AR validations and callbacks.
                # Luckily we have some DB level constraints
                Recipe.insert_all(recipe_batch)
            end
        end
    end
end
