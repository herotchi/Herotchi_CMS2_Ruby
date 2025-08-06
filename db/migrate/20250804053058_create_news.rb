class CreateNews < ActiveRecord::Migration[8.0]
  def change
    create_table :news do |t|
      t.string :title, limit: NewsConstants::TITLE_LENGTH_MAX, null: false, default: ""
      t.boolean :link_flg, null: false, default: NewsConstants::LINK_FLG_OFF
      t.string :url, limit: NewsConstants::URL_LENGTH_MAX
      t.text :overview
      t.date :release_date, null: false
      t.boolean :release_flg, null: false, default: NewsConstants::RELEASE_FLG_OFF

      t.timestamps
    end
  end
end
