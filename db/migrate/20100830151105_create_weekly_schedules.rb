class CreateWeeklySchedules < ActiveRecord::Migration
  def self.up
    create_table :weekly_schedules do |t|
      t.integer :section_id, :null => false
      t.date :date, :null => false
      t.boolean :is_published, :null => false, :default => false

      t.timestamps
    end

    add_index :weekly_schedules, :section_id
    add_index :weekly_schedules, :date
    add_index :weekly_schedules, [:section_id, :date], :unique => true
  end

  def self.down
    drop_table :weekly_schedules
  end
end
