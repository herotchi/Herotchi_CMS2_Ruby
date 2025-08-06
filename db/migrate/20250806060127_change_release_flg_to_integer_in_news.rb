class ChangeReleaseFlgToIntegerInNews < ActiveRecord::Migration[8.0]
  def change
    change_column :news, :release_flg, :integer, null: false, default: NewsConstants::RELEASE_FLG_OFF
  end
end
