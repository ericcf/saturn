require 'spec_helper'

describe PhysicianAlias do

  before(:each) do
    mock_physician = mock_model(Physician)
    Physician.stub!(:find).with(mock_physician.id, anything).
      and_return(mock_physician)
    @valid_attributes = {
      :physician_id => mock_physician.id,
      :initials => "abc",
      :short_name => "value for short_name"
    }
    PhysicianAlias.create(@valid_attributes).should be_valid
  end

  # database

  it { should have_db_column(:physician_id).with_options(:null => false) }

  it { should have_db_index(:physician_id).unique(true) }

  # associations

  it { should belong_to(:physician) }

  # validations

  it { should validate_presence_of(:physician) }

  it { should allow_value(nil).for(:initials) }

  it { should validate_format_of(:initials).with("EE") }

  it { should validate_format_of(:initials).not_with("abcd").
    with_message(/must be either 2 or 3 letters/) }

  # attribute cleanup

  it { should clean_text_attribute(:initials) }

  it { should clean_text_attribute(:short_name) }

end
