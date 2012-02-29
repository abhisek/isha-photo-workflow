class AddActiveInShoots < ActiveRecord::Migration
  def up
    add_column :shoots, :active, :boolean, :default => true
  end

  def down
    remove_column :shoots, :active
  end
end
