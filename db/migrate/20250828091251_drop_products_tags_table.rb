class DropProductsTagsTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :products_tags
  end
end
