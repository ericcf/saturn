class CreateMeetingRequests < ActiveRecord::Migration
  def self.up
    create_table :meeting_requests do |t|
      t.integer :requester_id, :null => false
      t.integer :section_id, :null => false
      t.integer :shift_id, :null => false
      t.string :status, :null => false, :default => "pending"
      t.date :start_date, :null => false
      t.date :end_date
      t.text :comments

      t.timestamps
    end

    add_index :meeting_requests, :requester_id
    add_index :meeting_requests, :section_id
    add_index :meeting_requests, :status
  end

  def self.down
    drop_table :meeting_requests
  end
end
