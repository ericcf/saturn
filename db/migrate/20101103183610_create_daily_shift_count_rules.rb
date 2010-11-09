class CreateDailyShiftCountRules < ActiveRecord::Migration
  def self.up
    create_table :daily_shift_count_rules do |t|
      t.integer :section_id, :null => false
      t.integer :shift_tag_id, :null => false
      t.integer :maximum

      t.timestamps
    end

    add_index :daily_shift_count_rules, :section_id
    add_index :daily_shift_count_rules, :shift_tag_id, :unique => true
  end

  def self.down
    drop_table :daily_shift_count_rules
  end
end
