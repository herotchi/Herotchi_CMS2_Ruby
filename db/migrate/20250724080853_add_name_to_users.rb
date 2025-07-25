class AddNameToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :name, :string, limit: UserConstants::NAME_LENGTH_MAX, null: false
    add_index :users, :name, unique: true
  end
end
