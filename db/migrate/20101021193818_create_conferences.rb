class CreateConferences < ActiveRecord::Migration
  def self.up
    create_table :conferences do |t|
      t.string :title
      t.text :description
      t.string :calcium_uid
      t.datetime :starts_at
      t.datetime :ends_at
      t.text :categories
      t.string :location
      t.string :contact

      t.timestamps
    end
  end

  def self.down
    drop_table :conferences
  end
end
