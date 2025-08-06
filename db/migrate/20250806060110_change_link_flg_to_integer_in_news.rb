class ChangeLinkFlgToIntegerInNews < ActiveRecord::Migration[8.0]
  def change
    change_column :news, :link_flg, :integer, null: false, default: NewsConstants::LINK_FLG_OFF
  end
end
