class CreateShiftWeekNotes < ActiveRecord::Migration
  def self.up
    create_table :shift_week_notes do |t|
      t.integer :shift_id, :null => false
      t.integer :weekly_schedule_id, :null => false
      t.string :text, :null => false
    end

    add_index :shift_week_notes, [:shift_id, :weekly_schedule_id], :unique => true
  end

  def self.down
    drop_table :shift_week_notes
  end
end
