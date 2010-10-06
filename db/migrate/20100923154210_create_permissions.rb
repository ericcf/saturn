class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.string :action, :null => false
      t.string :target_type, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :permissions
  end
end
