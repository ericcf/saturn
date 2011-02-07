class CreateHolidays < ActiveRecord::Migration
  def self.up
    create_table :holidays do |t|
      t.string :title, :null => false
      t.date :date, :null => false
    end

    add_index :holidays, :date
  end

  def self.down
    drop_table :holidays
  end
end
