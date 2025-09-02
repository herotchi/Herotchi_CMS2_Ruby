class CreateMedia < ActiveRecord::Migration[8.0]
  def change
    create_table :media do |t|
      t.integer :media_flg, null: false, limit: MediaConstants::MEDIA_FLG_LIMIT
      t.string :alt, null: false, limit: MediaConstants::ALT_LENGTH_MAX
      t.string :url, null: false, limit: MediaConstants::URL_LENGTH_MAX
      t.integer :release_flg, null: false, limit: MediaConstants::RELEASE_FLG_LIMIT, default: MediaConstants::RELEASE_FLG_OFF

      t.timestamps
    end
  end
end
