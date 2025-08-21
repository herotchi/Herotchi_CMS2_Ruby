class CreateSecondCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :second_categories do |t|
      t.references :first_category, null: false, foreign_key: { on_delete: :restrict }
      t.string :name, limit: SecondCategoryConstants::NAME_LENGTH_MAX, null: false, default: ""

      t.timestamps
    end
    # first_category_idとnameの組み合わせにユニーク制約
    add_index :second_categories, [:first_category_id, :name], unique: true
  end
end
