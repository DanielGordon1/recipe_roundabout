class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.references :user, null: true, foreign_key: true
      t.string :title, null: false
      t.integer :cooking_time_minutes
      t.integer :preparation_time_minutes
      t.float :rating
      t.string :image_url
      t.string :cuisine
      t.references :recipe_category, null: true, foreign_key: true

      t.timestamps
    end
  end
end
