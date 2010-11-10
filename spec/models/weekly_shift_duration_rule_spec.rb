require 'spec_helper'

describe WeeklyShiftDurationRule do

  before(:each) do
    mock_section = stub_model(Section, :valid? => true)
    Section.stub!(:find).with(mock_section.id, anything).
      and_return(mock_section)
    @valid_attributes = {
      :section => mock_section
    }
    @rule = WeeklyShiftDurationRule.create(@valid_attributes)
    @rule.should be_valid
  end

  # database

  it { should have_db_column(:section_id).with_options(:null => false) }

  it { should have_db_index(:section_id) }

  # attributes

  it { should allow_mass_assignment_of(:section) }

  # associations

  it { should belong_to(:section) }

  # validations

  it { should validate_presence_of(:section) }

  it { should validate_associated(:section) }

  it { should validate_numericality_of(:minimum) }

  it { should validate_numericality_of(:maximum) }

  it { should allow_value(nil).for(:minimum) }

  it { should allow_value(10.0).for(:minimum) }

  it { should_not allow_value(-1.0).for(:minimum) }

  it { should_not allow_value(10000).for(:minimum) }

  it { should allow_value(nil).for(:maximum) }

  it { should allow_value(10.0).for(:maximum) }

  it { should_not allow_value(-1.0).for(:maximum) }

  it { should_not allow_value(10000).for(:maximum) }

  it "is valid when the maximum is greater than the minimum" do
    @rule.update_attributes(:minimum => 0.0, :maximum => 5.0)
    @rule.should be_valid
  end

  it "is not valid when the maximum is less than the minimum" do
    @rule.update_attributes(:minimum => 10.0, :maximum => 1.0)
    @rule.should_not be_valid
  end

  # methods

  describe ".process(:assignments_by_physician)" do

    context "a minimum is defined" do

      it "returns physicians without assignments" do
        @rule.update_attribute(:minimum, 1.0)
        mock_physician = stub_model(Physician)
        @rule.section.stub!(:members).and_return([mock_physician])
        group_below_minimum, group_above_maximum = @rule.process({})
        group_below_minimum.keys.should include(mock_physician)
      end
    end

    it "returns physicians below the minimum" do
      @rule.update_attributes(:minimum => 2.0, :maximum => 100.0)
      mock_physician = stub_model(Physician)
      mock_assignment = stub_model(Assignment, :fixed_duration => 1.0)
      @rule.section.stub!(:members) { [] }
      group_below_minimum, group_above_maximum = @rule.process({
        mock_physician => [mock_assignment]
      })
      group_below_minimum.should include(mock_physician)
    end

    it "returns physicians above the maximum" do
      @rule.update_attributes(:minimum => 0.0, :maximum => 1.0)
      mock_physician = stub_model(Physician)
      mock_assignment = stub_model(Assignment, :fixed_duration => 2.0)
      @rule.section.stub!(:members) { [] }
      group_below_minimum, group_above_maximum = @rule.process({
        mock_physician => [mock_assignment]
      })
      group_above_maximum.should include(mock_physician)
    end
  end
end
