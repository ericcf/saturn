class CreateShifts < ActiveRecord::Migration
  def self.up
    create_table :shifts do |t|
      t.integer :section_id, :null => false
      t.string :title, :null => false
      t.string :description
      t.decimal :duration, :null => false, :precision => 2, :scale => 1, :default => 0.5
      t.integer :position, :null => false, :default => 1
      t.string :phone
      t.string :display_color
      t.date :retired_on

      t.timestamps
    end

    add_index :shifts, :section_id
  end

  def self.down
    drop_table :shifts
  end
end
