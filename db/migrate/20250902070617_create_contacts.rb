class CreateContacts < ActiveRecord::Migration[8.0]
  def change
    create_table :contacts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :no, null: false, limit: ContactConstants::NO_LENGTH, default: ""
      t.text :body, null: false
      t.integer :status, null: false, limit: ContactConstants::STATUS_LIMIT, default: ContactConstants::STATUS_NOT_STARTED

      t.timestamps
    end
  end
end
