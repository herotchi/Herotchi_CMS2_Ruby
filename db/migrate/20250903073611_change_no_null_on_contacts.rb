class ChangeNoNullOnContacts < ActiveRecord::Migration[8.0]
  def change
    change_column_null :contacts, :no, true
  end
end
