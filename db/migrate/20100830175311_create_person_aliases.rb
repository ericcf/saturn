class CreatePersonAliases < ActiveRecord::Migration
  def self.up
    create_table :person_aliases do |t|
      t.integer :person_id, :null => false
      t.string :initials
      t.string :short_name

      t.timestamps
    end

    add_index :person_aliases, :person_id, :unique => true
  end

  def self.down
    drop_table :person_aliases
  end
end
