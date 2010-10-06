require 'spec_helper'

describe FeedbackStatus do

  before(:each) do
    @valid_attributes = {
      :name => "valid status name"
    }
    @status = FeedbackStatus.create(@valid_attributes)
    @status.should be_valid
  end

  # database

  it { should have_db_column(:name).with_options(:null => false) }

  it { should have_db_index(:name).unique(true) }

  # associations

  it { should have_many(:tickets).dependent(:nullify) }

  # validations

  it { should validate_uniqueness_of(:name) }

  it { should validate_presence_of(:name) }
end
