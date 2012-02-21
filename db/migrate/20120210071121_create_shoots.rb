class CreateShoots < ActiveRecord::Migration
  def change
    create_table :shoots do |t|
      t.string  :event
      t.string  :description
      t.string  :photographer
      t.integer :user_id
      t.binary  :meta

      t.date    :shot_on
      t.date    :reported_on

      t.timestamps
    end

    add_index :shoots, :id
    add_index :shoots, :event
    add_index :shoots, :description
    add_index :shoots, :photographer
    add_index :shoots, :shot_on
    add_index :shoots, :reported_on

  end
end
