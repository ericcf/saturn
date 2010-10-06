class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.integer :contact_id
      t.integer :group_id
    end

    add_index :memberships, :contact_id
    add_index :memberships, :group_id
  end

  def self.down
    drop_table :memberships
  end
end
