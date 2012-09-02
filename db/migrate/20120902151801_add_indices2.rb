class AddIndices2 < ActiveRecord::Migration
  def up
    add_index :shoots, :active
  end

  def down
  end
end
