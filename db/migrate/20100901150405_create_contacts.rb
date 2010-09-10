# note that this is only used in the test environment
class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.string :type
      t.string :given_name
      t.string :family_name
      t.string :other_given_names
      t.string :suffixes
      t.date :employment_starts_on
      t.date :employment_ends_on
    end
  end

  def self.down
    drop_table :contacts
  end
end
