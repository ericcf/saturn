class CreateFeedbackStatuses < ActiveRecord::Migration
  def self.up
    create_table :feedback_statuses do |t|
      t.string :name, :null => false
      t.boolean :default, :default => false

      t.timestamps
    end

    add_index :feedback_statuses, :name, :unique => true
  end

  def self.down
    drop_table :feedback_statuses
  end
end
