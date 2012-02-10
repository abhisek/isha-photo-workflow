class CreateShootLogs < ActiveRecord::Migration
  def change
    create_table :shoot_logs do |t|
      t.integer   :shoot_id
      t.integer   :user_id
      t.string    :msg

      t.timestamps
    end
  end
end
