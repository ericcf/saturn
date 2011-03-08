class CreateSectionRoleAssignments < ActiveRecord::Migration
  def self.up
    create_table :section_role_assignments do |t|
      t.integer :section_id, :null => false
      t.integer :role_id, :null => false

      t.timestamps
    end

    add_index :section_role_assignments, :section_id
    add_index :section_role_assignments, :role_id
    add_index :section_role_assignments, [:section_id, :role_id], :unique => true
  end

  def self.down
    drop_table :section_role_assignments
  end
end
