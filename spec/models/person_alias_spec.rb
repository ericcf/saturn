require 'spec_helper'

describe PersonAlias do

  before(:each) do
    mock_person = mock_model(Person)
    Person.stub!(:find).with(mock_person.id, anything).and_return(mock_person)
    @valid_attributes = {
      :person_id => mock_person.id,
      :initials => "abc",
      :short_name => "value for short_name"
    }
    PersonAlias.create(@valid_attributes).should be_valid
  end

  # database

  it { should have_db_column(:person_id).with_options(:null => false) }

  it { should have_db_index(:person_id).unique(true) }

  # associations

  it { should belong_to(:person) }

  # validations

  it { should validate_presence_of(:person) }

  it { should allow_value(nil).for(:initials) }

  it { should validate_format_of(:initials).with("EE") }

  it { should validate_format_of(:initials).not_with("abcd").
    with_message(/must be either 2 or 3 letters/) }

  # attribute cleanup

  it { should clean_attribute(:initials) }

  it { should clean_attribute(:short_name) }

end
