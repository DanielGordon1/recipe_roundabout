class RecipeParser
    
    SUPPORTED_FORMATS = %w[json].freeze
    
    def initialize(file_path)
        extension = file_extension(file_path)
        
        unless SUPPORTED_FORMATS.include?(extension)
            raise ArgumentError, "Unsupported file format: .#{extension}. Only #{SUPPORTED_FORMATS.join(', ')} files are supported."
        end
        
        case extension
        when 'json'
            parse_json(file_path)
        else
            raise ArgumentError, "Unsupported file format: .#{extension}."
        end
    end
    
    def self.file_extension(file_path)
        File.extname(file_path).delete('.')
    end
    
    def self.parse_json(file_path)
        json_data = File.read(file_path)
        # When working with a large data set we would ideally do this is batches to lower the amount of SQL inserts and speed up the process, but for now this fine.
        recipes = JSON.parse(json_data)
        # Load all categories and users before the loop to prevent looped queries.
        categories = RecipeCategory.all
        authors = Users.all
        recipes.map do |recipe_data|
            {
                title: recipe_data['title'],
                cooking_time_minutes: recipe_data['cook_time'],
                preparation_time_minutes: ['prep_time'],
                ingredients: recipe_data['ingredients'],
                rating: recipe_data['ratings'],
                cuisine: recipe_data['cuisine'],
                category: categories.find {|category| category.name == recipe_data['category']},
                author: authors.find { |author| author.name == recipe_data['author']},
                image: recipe_data['image']
            }
        end
    end
end
