class CreateShifts < ActiveRecord::Migration
  def self.up
    create_table :shifts do |t|
      t.string :type
      t.string :title, :null => false
      t.string :description
      t.decimal :duration, :null => false, :precision => 2, :scale => 1, :default => 0.5
      t.string :phone
    end
  end

  def self.down
    drop_table :shifts
  end
end
