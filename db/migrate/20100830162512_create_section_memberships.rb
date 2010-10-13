class CreateSectionMemberships < ActiveRecord::Migration
  def self.up
    create_table :section_memberships do |t|
      t.integer :physician_id, :null => false
      t.integer :section_id, :null => false

      t.timestamps
    end

    add_index :section_memberships, [:physician_id, :section_id], :unique => true
    add_index :section_memberships, :physician_id
    add_index :section_memberships, :section_id
  end

  def self.down
    drop_table :section_memberships
  end
end
