require 'spec_helper'

describe SectionMembership do

  let(:mock_physician) do
    mock_model(Physician, :primary_email => "foo@bar.com")
  end
  let(:mock_section) { mock_model(Section) }
  let(:valid_attributes) do
    {
      :physician_id => mock_physician.id,
      :section => mock_section
    }
  end
  let(:section_membership) { SectionMembership.create!(valid_attributes) }
  
  before(:each) do
    Physician.stub!(:find).with(mock_physician.id) { mock_physician }
    Section.stub!(:find).with(mock_section.id, anything) { mock_section }
  end

  subject { section_membership }

  # database

  it { should have_db_column(:physician_id).with_options(:null => false) }

  it { should have_db_column(:section_id).with_options(:null => false) }

  it { should have_db_index(:physician_id) }

  it { should have_db_index(:section_id) }

  it { should have_db_index([:physician_id, :section_id]).unique(true) }

  # associations

  it { should belong_to(:section) }

  # validations

  it { should validate_presence_of(:physician_id) }

  it { should validate_presence_of(:section) }

  it { should validate_uniqueness_of(:physician_id).scoped_to(:section_id) }
end
