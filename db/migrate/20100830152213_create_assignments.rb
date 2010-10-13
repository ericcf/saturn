class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :assignments do |t|
      t.integer :weekly_schedule_id, :null => false
      t.integer :shift_id, :null => false
      t.integer :physician_id, :null => false
      t.date :date, :null => false
      t.integer :position, :null => false, :default => 1
      t.string :public_note
      t.string :private_note
      t.decimal :duration, :precision => 2, :scale => 1

      t.timestamps
    end

    add_index :assignments, [:weekly_schedule_id, :shift_id]
    add_index :assignments, :weekly_schedule_id
    add_index :assignments, :physician_id
  end

  def self.down
    drop_table :assignments
  end
end
