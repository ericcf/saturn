class CreateVacationRequests < ActiveRecord::Migration
  def self.up
    create_table :vacation_requests do |t|
      t.integer :requester_id, :null => false
      t.integer :section_id, :null => false
      t.integer :shift_id, :null => false
      t.string :status, :null => false, :default => "pending"
      t.date :start_date, :null => false
      t.date :end_date
      t.text :comments

      t.timestamps
    end

    add_index :vacation_requests, :requester_id
    add_index :vacation_requests, :section_id
    add_index :vacation_requests, :status
  end

  def self.down
    drop_table :vacation_requests
  end
end
