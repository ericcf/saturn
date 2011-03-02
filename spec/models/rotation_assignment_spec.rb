require 'spec_helper'

describe RotationAssignment do

  let(:mock_physician) { mock_model(Physician) }
  let(:mock_rotation) { mock_model(Rotation) }
  let(:today) { Date.today }
  let(:valid_attributes) do
    {
      :physician => mock_physician,
      :rotation => mock_rotation,
      :starts_on => today,
      :ends_on => today
    }
  end
  let(:assignment) { RotationAssignment.create!(valid_attributes) }

  before(:each) do
    Physician.stub!(:find).with(mock_physician.id, anything) { mock_physician }
    Rotation.stub!(:find).with(mock_rotation.id, anything) { mock_rotation }
  end

  subject { assignment }

  # database
  
  it { should have_db_column(:physician_id).with_options(:null => false) }

  it { should have_db_column(:rotation_id).with_options(:null => false) }

  it { should have_db_column(:starts_on).with_options(:null => false) }

  it { should have_db_column(:ends_on).with_options(:null => false) }

  it { should have_db_index(:physician_id) }

  it { should have_db_index(:rotation_id) }

  # validation
  
  it { should validate_presence_of(:physician) }
  
  it { should validate_presence_of(:rotation) }
  
  it { should validate_presence_of(:starts_on) }
  
  it { should validate_presence_of(:ends_on) }

  it "should not allow ends_on to occur before starts_on" do
    RotationAssignment.create(valid_attributes.merge({
      :starts_on => Date.today,
      :ends_on => Date.yesterday
    })).should_not be_valid
  end
end
