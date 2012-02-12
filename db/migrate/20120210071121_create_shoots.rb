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

    add_index :shoots, :id
    add_index :shoots, :event
    add_index :shoots, :description
    add_index :shoots, :photographer
  end
end
