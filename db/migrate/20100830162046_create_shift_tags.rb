class CreateShiftTags < ActiveRecord::Migration
  def self.up
    create_table :shift_tags do |t|
      t.integer :section_id, :null => false
      t.string :title, :null => false

      t.timestamps
    end

    add_index :shift_tags, :section_id
    add_index :shift_tags, [:section_id, :title], :unique => true
  end

  def self.down
    drop_table :shift_tags
  end
end
