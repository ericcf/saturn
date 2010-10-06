require 'spec_helper'

describe FeedbackTicket do

  before(:each) do
    @valid_attributes = {
      :description => "The site is broken."
    }
    @ticket = FeedbackTicket.create(@valid_attributes)
    @ticket.should be_valid
  end

  # database

  it { should have_db_column(:description).with_options(:null => false) }

  it { should have_db_index(:user_id) }

  it { should have_db_index(:status_id) }

  # associations

  it { should belong_to(:user) }

  it { should belong_to(:status) }

  # validations

  it { should validate_associated(:user) }

  it { should validate_associated(:status) }

  it { should validate_presence_of(:description) }
end
