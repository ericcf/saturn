class CreateShiftTagAssignments < ActiveRecord::Migration
  def self.up
    create_table :shift_tag_assignments do |t|
      t.integer :shift_tag_id, :null => false
      t.integer :section_shift_id, :null => false
    end

    add_index :shift_tag_assignments, [:section_shift_id, :shift_tag_id],
      :unique => true
    add_index :shift_tag_assignments, :section_shift_id
    add_index :shift_tag_assignments, :shift_tag_id
  end

  def self.down
    drop_table :shift_tag_assignments
  end
end
