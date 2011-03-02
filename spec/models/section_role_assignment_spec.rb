require 'spec_helper'

describe SectionRoleAssignment do

  let(:mock_section) { stub_model(Section, :valid? => true) }
  let(:mock_role) { stub_model(Deadbolt::Role, :valid? => true) }
  let(:valid_attributes) do
    {
      :section => mock_section,
      :role => mock_role
    }
  end
  let(:assignment) { SectionRoleAssignment.create!(valid_attributes) }

  before(:each) do
    Section.stub!(:find).with(mock_section.id, anything) { mock_section }
    Deadbolt::Role.stub!(:find).with(mock_role.id, anything) { mock_role }
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
