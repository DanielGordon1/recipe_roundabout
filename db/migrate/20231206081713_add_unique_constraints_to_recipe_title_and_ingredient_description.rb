class AddUniqueConstraintsToRecipeTitleAndIngredientDescription < ActiveRecord::Migration[7.0]
  def change
    # I'd prefer to create a unique index with title and user_id, but since that is mostly empty let's use image_url.
    add_index :recipes, [:title, :image_url],  unique: true
    add_index :ingredients, [:recipe_id, :description], unique: true
  end
end

# Bread Machine Focaccia
