require 'spec_helper'

describe SectionMembership do
  
  before(:each) do
    mock_person = stub_model(Person)
    Person.stub!(:find).with(mock_person.id, anything).and_return(mock_person)
    mock_section = stub_model(Section)
    Section.stub!(:find).with(mock_section.id, anything).
      and_return(mock_section)
    @valid_attributes = {
      :person_id => mock_person.id,
      :section_id => mock_section.id
    }
    SectionMembership.create(@valid_attributes).should be_valid
  end

  # database

  it { should have_db_column(:person_id).with_options(:null => false) }

  it { should have_db_column(:section_id).with_options(:null => false) }

  it { should have_db_index(:person_id) }

  it { should have_db_index(:section_id) }

  it { should have_db_index([:person_id, :section_id]).unique(true) }

  # associations

  it { should belong_to(:person) }

  it { should belong_to(:section) }

  # validations

  it { should validate_presence_of(:person) }

  it { should validate_presence_of(:section) }

  #it { should validate_uniqueness_of(:person_id).scoped_to(:section_id) }
end
