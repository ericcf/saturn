require 'spec_helper'

describe VacationRequest do

  before(:each) do
    @mock_physician = mock_model(Physician)
    Physician.stub!(:find).with(@mock_physician.id, anything).
      and_return(@mock_physician)
    @mock_section = mock_model(Section)
    Section.stub!(:find).with(@mock_section.id, anything).
      and_return(@mock_section)
    @valid_attributes = {
      :requester => @mock_physician,
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

  it { should have_db_index(:section_id) }

  # associations

  it { should belong_to(:requester) }

  it { should belong_to(:section) }

  # validations

  it { should validate_presence_of(:requester) }

  it { should validate_presence_of(:section) }

  it { should validate_presence_of(:dates) }
end
