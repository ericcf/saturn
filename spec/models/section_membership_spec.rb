require 'spec_helper'

describe SectionMembership do
  
  before(:each) do
    mock_physician = stub_model(Physician)
    Physician.stub!(:find).with(mock_physician.id, anything).
      and_return(mock_physician)
    mock_section = stub_model(Section)
    Section.stub!(:find).with(mock_section.id, anything).
      and_return(mock_section)
    @valid_attributes = {
      :physician_id => mock_physician.id,
      :section_id => mock_section.id
    }
    SectionMembership.create(@valid_attributes).should be_valid
  end

  # database

  it { should have_db_column(:physician_id).with_options(:null => false) }

  it { should have_db_column(:section_id).with_options(:null => false) }

  it { should have_db_index(:physician_id) }

  it { should have_db_index(:section_id) }

  it { should have_db_index([:physician_id, :section_id]).unique(true) }

  # associations

  it { should belong_to(:physician) }

  it { should belong_to(:section) }

  # validations

  it { should validate_presence_of(:physician) }

  it { should validate_presence_of(:section) }

  it { should validate_uniqueness_of(:physician_id).scoped_to(:section_id) }
end
