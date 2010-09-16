require 'spec_helper'

describe RotationAssignment do

  before(:each) do
    @mock_person = mock_model(Person)
    Person.stub!(:find).with(@mock_person.id, anything).and_return(@mock_person)
    @mock_rotation = mock_model(Rotation)
    Rotation.stub!(:find).with(@mock_rotation.id, anything).
      and_return(@mock_rotation)
    @valid_attributes = {
      :person => @mock_person,
      :rotation => @mock_rotation,
      :starts_on => Date.today,
      :ends_on => Date.today
    }
    @assignment = RotationAssignment.create(@valid_attributes)
    @assignment.should be_valid
  end

  # database
  
  it { should have_db_column(:person_id).with_options(:null => false) }

  it { should have_db_column(:rotation_id).with_options(:null => false) }

  it { should have_db_column(:starts_on).with_options(:null => false) }

  it { should have_db_column(:ends_on).with_options(:null => false) }

  # validation
  
  it { should validate_presence_of(:person) }
  
  it { should validate_presence_of(:rotation) }
  
  it { should validate_presence_of(:starts_on) }
  
  it { should validate_presence_of(:ends_on) }

  it "should not allow ends_on to occur before starts_on" do
    RotationAssignment.create(@valid_attributes.merge({
      :starts_on => Date.today,
      :ends_on => Date.yesterday
    })).should_not be_valid
  end
end
