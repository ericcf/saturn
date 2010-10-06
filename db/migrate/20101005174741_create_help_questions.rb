class CreateHelpQuestions < ActiveRecord::Migration
  def self.up
    create_table :help_questions do |t|
      t.text :title
      t.text :answer

      t.timestamps
    end
  end

  def self.down
    drop_table :help_questions
  end
end
