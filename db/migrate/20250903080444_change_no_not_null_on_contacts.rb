class ChangeNoNotNullOnContacts < ActiveRecord::Migration[8.0]
  def change
    change_column_null :contacts, :no, false
  end
end
