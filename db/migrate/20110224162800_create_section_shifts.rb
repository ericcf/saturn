class CreateSectionShifts < ActiveRecord::Migration
  def self.up
    create_table :section_shifts do |t|
      t.integer :section_id, :null => false
      t.integer :shift_id, :null => false
      t.integer :position, :null => false, :default => 1
      t.string :display_color
      t.date :retired_on
    end

    add_index :section_shifts, [:section_id, :shift_id], :unique => true
    add_index :section_shifts, :section_id
    add_index :section_shifts, :shift_id
  end

  def self.down
    drop_table :section_shifts
  end
end
