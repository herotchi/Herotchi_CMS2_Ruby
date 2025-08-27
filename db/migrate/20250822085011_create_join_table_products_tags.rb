class CreateJoinTableProductsTags < ActiveRecord::Migration[8.0]
  def change
    create_join_table :products, :tags do |t|
      t.index [:product_id, :tag_id], unique: true
      t.index [:tag_id, :product_id]
    end
  end
end
