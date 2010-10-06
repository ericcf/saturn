class CreateFeedbackTickets < ActiveRecord::Migration
  def self.up
    create_table :feedback_tickets do |t|
      t.integer :user_id
      t.string :request_url
      t.integer :status_id
      t.text :description, :null => false
      t.text :comments

      t.timestamps
    end

    add_index :feedback_tickets, :user_id
    add_index :feedback_tickets, :status_id
  end

  def self.down
    drop_table :feedback_tickets
  end
end
