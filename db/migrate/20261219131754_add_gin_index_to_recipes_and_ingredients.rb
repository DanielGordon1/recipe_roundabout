class AddGinIndexToRecipesAndIngredients < ActiveRecord::Migration[7.0]
  def change
    enable_extension "btree_gin"

    add_index :recipes, :title_searchable, using: :gin
    add_index :ingredients, :description_searchable, using: :gin
  end
end
