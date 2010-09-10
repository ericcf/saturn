class CreateShiftTagAssignments < ActiveRecord::Migration
  def self.up
    create_table :shift_tag_assignments do |t|
      t.integer :shift_tag_id, :null => false
      t.integer :shift_id, :null => false

      t.timestamps
    end

    add_index :shift_tag_assignments, [:shift_id, :shift_tag_id], :unique => true
    add_index :shift_tag_assignments, :shift_id
    add_index :shift_tag_assignments, :shift_tag_id
  end

  def self.down
    drop_table :shift_tag_assignments
  end
end
