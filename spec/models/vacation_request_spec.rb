require 'spec_helper'

describe VacationRequest do

  before(:each) do
    @mock_person = mock_model(Person)
    Person.stub!(:find).with(@mock_person.id, anything).and_return(@mock_person)
    @mock_section = mock_model(Section)
    Section.stub!(:find).with(@mock_section.id, anything).
      and_return(@mock_section)
    @valid_attributes = {
      :requester => @mock_person,
      :section => @mock_section,
      :dates => [Date.today]
    }
    @vacation_request = VacationRequest.create(@valid_attributes)
    @vacation_request.should be_valid
  end

  # database

  it { should have_db_column(:requester_id).with_options(:null => false) }

  it { should have_db_column(:section_id).with_options(:null => false) }

  it { should have_db_index(:requester_id) }

  # associations

  it { should belong_to(:requester) }

  it { should belong_to(:section) }

  # validations

  it { should validate_presence_of(:requester) }

  it { should validate_presence_of(:section) }

  it { should validate_presence_of(:dates) }
end
