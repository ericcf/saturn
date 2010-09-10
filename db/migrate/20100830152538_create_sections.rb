class CreateSections < ActiveRecord::Migration
  def self.up
    create_table :sections do |t|
      t.string :title, :null => false
      t.text :description

      t.timestamps
    end

    add_index :sections, :title, :unique => true
  end

  def self.down
    drop_table :sections
  end
end
