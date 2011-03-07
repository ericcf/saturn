class CreateAssignmentRequests < ActiveRecord::Migration
  def self.up
    create_table :assignment_requests do |t|
      t.integer :requester_id, :null => false
      t.integer :shift_id, :null => false
      t.string :status, :null => false, :default => "pending"
      t.date :start_date, :null => false
      t.date :end_date
      t.text :comments

      t.timestamps
    end

    add_index :assignment_requests, :requester_id
  end

  def self.down
    drop_table :assignment_requests
  end
end
