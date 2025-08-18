class CreateFirstCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :first_categories do |t|
      t.string :name, limit: FirstCategoryConstants::NAME_LENGTH_MAX, null: false, default: ""

      t.timestamps
    end
    add_index :first_categories, :name, unique: true
  end
end
