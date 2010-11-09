class CreateWeeklyShiftDurationRules < ActiveRecord::Migration
  def self.up
    create_table :weekly_shift_duration_rules do |t|
      t.integer :section_id, :null => false
      t.decimal :maximum, :precision => 4, :scale => 1
      t.decimal :minimum, :precision => 4, :scale => 1

      t.timestamps
    end

    add_index :weekly_shift_duration_rules, :section_id
  end

  def self.down
    drop_table :weekly_shift_duration_rules
  end
end
