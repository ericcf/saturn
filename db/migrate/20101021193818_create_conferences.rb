class CreateConferences < ActiveRecord::Migration
  def self.up
    create_table :conferences do |t|
      t.string :title, :null => false
      t.string :presenter
      t.text :description
      t.string :external_uid
      t.datetime :starts_at, :null => false
      t.datetime :ends_at, :null => false
      t.text :categories
      t.string :location
      t.string :contact

      t.timestamps
    end

    add_index :conferences, :external_uid, :unique => true
    add_index :conferences, :starts_at
    add_index :conferences, [:title, :starts_at, :ends_at], :unique => true
  end

  def self.down
    drop_table :conferences
  end
end
