class CreateIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :ingredients do |t|
      t.string :description
      # Having null:true is far from ideal, but currently neccesary to make sure we can run insert_all.
      t.references :recipe, null: true, foreign_key: true

      t.timestamps
    end
  end
end
