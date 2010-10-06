class CreatePhones < ActiveRecord::Migration
  def self.up
    create_table :phones do |t|
      t.integer :contact_id
      t.string :value
    end

    add_index :phones, :contact_id
  end

  def self.down
    drop_table :phones
  end
end
