class ChangeReleaseFlgTypeToTinyintInNews < ActiveRecord::Migration[8.0]
  def up
    change_column :news, :release_flg, :integer, null: false, limit: NewsConstants::RELEASE_FLG_LIMIT, default: NewsConstants::RELEASE_FLG_OFF
  end

  def down
    change_column :news, :release_flg, :integer, null: false, default: NewsConstants::RELEASE_FLG_OFF
  end
end
