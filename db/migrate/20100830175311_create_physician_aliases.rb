class CreatePhysicianAliases < ActiveRecord::Migration
  def self.up
    create_table :physician_aliases do |t|
      t.integer :physician_id, :null => false
      t.string :initials
      t.string :short_name

      t.timestamps
    end

    add_index :physician_aliases, :physician_id, :unique => true
  end

  def self.down
    drop_table :physician_aliases
  end
end
