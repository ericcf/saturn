class CreateRotationAssignments < ActiveRecord::Migration
  def self.up
    create_table :rotation_assignments do |t|
      t.integer :person_id, :null => false
      t.integer :rotation_id, :null => false
      t.date :starts_on, :null => false
      t.date :ends_on, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :rotation_assignments
  end
end
