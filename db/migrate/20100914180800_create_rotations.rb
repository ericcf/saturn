class CreateRotations < ActiveRecord::Migration
  def self.up
    create_table :rotations do |t|
      t.string :title, :null => false
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :rotations
  end
end
