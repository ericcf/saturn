require 'spec_helper'

describe PhysicianAlias do

  let(:mock_physician) { mock_model(Physician) }
  let(:valid_attributes) do
    {
      :physician_id => mock_physician.id,
      :initials => "abc",
      :short_name => "value for short_name"
    }
  end
  let(:physician_alias) { PhysicianAlias.create!(valid_attributes) }

  before(:each) do
    Physician.stub!(:find).with(mock_physician.id, anything) { mock_physician }
  end

  subject { physician_alias }

  # database

  it { should have_db_column(:physician_id).with_options(:null => false) }

  it { should have_db_index(:physician_id).unique(true) }

  # associations

  it { should belong_to(:physician) }

  # validations

  it { should validate_presence_of(:physician_id) }

  it { should allow_value(nil).for(:initials) }

  it { should validate_format_of(:initials).with("EE") }

  it { should validate_format_of(:initials).not_with("abcd").
    with_message(/must be either 2 or 3 letters/) }

  # attribute cleanup

  it { should clean_text_attribute(:initials) }

  it { should clean_text_attribute(:short_name) }

end
