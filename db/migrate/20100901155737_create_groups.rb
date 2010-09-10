class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :type
      t.string :title
    end
  end

  def self.down
    drop_table :groups
  end
end
