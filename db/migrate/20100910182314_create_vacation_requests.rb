class CreateVacationRequests < ActiveRecord::Migration
  def self.up
    create_table :vacation_requests do |t|
      t.integer :requester_id, :null => false
      t.integer :section_id, :null => false
      t.text :dates, :null => false
      t.text :comments

      t.timestamps
    end

    add_index :vacation_requests, :requester_id
  end

  def self.down
    drop_table :vacation_requests
  end
end
