class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.references :first_category, null: false, foreign_key: true
      t.references :second_category, null: false, foreign_key: true
      t.string :name, limit: ProductConstants::NAME_LENGTH_MAX, null: false, default: ""
      t.string :image, null: false, default: ""
      t.text :detail, null: false
      t.integer :release_flg, null: false, limit: ProductConstants::RELEASE_FLG_LIMIT, default: ProductConstants::RELEASE_FLG_OFF

      t.timestamps
    end
  end
end
