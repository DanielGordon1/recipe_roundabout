class CreateUsersRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :users_recipes do |t|

      t.timestamps
    end
  end
end
