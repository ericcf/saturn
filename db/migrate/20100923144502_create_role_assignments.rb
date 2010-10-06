class CreateRoleAssignments < ActiveRecord::Migration
  def self.up
    create_table :role_assignments do |t|
      t.integer :user_id, :null => false
      t.integer :role_id, :null => false

      t.timestamps
    end

    add_index :role_assignments, [:role_id, :user_id], :unique => true
  end

  def self.down
    drop_table :role_assignments
  end
end
