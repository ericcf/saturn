require 'spec_helper'

describe SectionRoleAssignment do

  before(:each) do
    mock_section = stub_model(Section, :valid? => true)
    Section.stub!(:find).with(mock_section.id, anything) { mock_section }
    mock_role = stub_model(Deadbolt::Role, :valid? => true)
    Deadbolt::Role.stub!(:find).with(mock_role.id, anything) { mock_role }
    @valid_attributes = {
      :section => mock_section,
      :role => mock_role
    }
    @assignment = SectionRoleAssignment.new(@valid_attributes)
  end
  
  it "is valid with valid attributes" do
    @assignment.should be_valid
  end

  # database
  
  it { should have_db_column(:section_id).with_options(:null => false) }
  
  it { should have_db_column(:role_id).with_options(:null => false) }

  it { should have_db_index(:section_id) }

  it { should have_db_index(:role_id) }

  it { should have_db_index([:section_id, :role_id]).unique(true) }

  # associations

  it { should belong_to(:section) }

  it { should belong_to(:role) }

  # validations

  it { should validate_presence_of(:section) }

  it { should validate_presence_of(:role) }

  it { should validate_associated(:section) }

  it { should validate_associated(:role) }
end
