class CreateShoots < ActiveRecord::Migration
  def change
    create_table :shoots do |t|
      t.string  :event
      t.string  :description
      t.string  :photographer
      t.integer :user_id
      t.binary  :meta

      t.timestamps
    end
  end
end
