class AddTextSearchColumnToRecipesAndIngredients < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      ALTER TABLE recipes
      ADD COLUMN title_searchable tsvector GENERATED ALWAYS AS (
        setweight(to_tsvector('english', coalesce(title, '')), 'A')
      ) STORED;

      ALTER TABLE ingredients
      ADD COLUMN description_searchable tsvector GENERATED ALWAYS AS (
        setweight(to_tsvector('english', coalesce(description, '')), 'B')
      ) STORED;
    SQL
  end

  def down
    remove_column :recipes, :title_searchable
    remove_column :ingredients, :description_searchable
  end
end
