class ChangeLinkFlgTypeToTinyintInNews < ActiveRecord::Migration[8.0]
  def up
    change_column :news, :link_flg, :integer, null: false, limit: NewsConstants::LINK_FLG_LIMIT, default: NewsConstants::LINK_FLG_OFF
  end

  def down
    change_column :news, :link_flg, :integer, null: false, default: NewsConstants::LINK_FLG_OFF
  end
end
