class AddUniqueIndexToAssignments < ActiveRecord::Migration
  def change
    add_index :assignments, [:date, :physician_id, :shift_id], :unique => true
  end
end
