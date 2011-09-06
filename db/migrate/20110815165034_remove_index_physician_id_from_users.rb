class RemoveIndexPhysicianIdFromUsers < ActiveRecord::Migration
  def up
    #remove_index :users, :physician_id
  end

  def down
    add_index :users, :physician_id, :unique => true
  end
end
