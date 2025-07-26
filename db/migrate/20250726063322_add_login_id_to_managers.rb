class AddLoginIdToManagers < ActiveRecord::Migration[8.0]
  def change
    add_column :managers, :login_id, :string, limit: ManagerConstants::LOGIN_ID_LENGTH_MAX, null: false, default: ""
    add_index :managers, :login_id, unique: true
  end
end
