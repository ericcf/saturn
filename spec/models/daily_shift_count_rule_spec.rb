require 'spec_helper'

describe DailyShiftCountRule do

  let(:mock_section) { stub_model(Section, :valid? => true) }
  let(:mock_shift_tag) { stub_model(ShiftTag, :valid? => true) }
  let(:valid_attributes) do
    {
      :section => mock_section,
      :shift_tag => mock_shift_tag
    }
  end
  let(:rule) { DailyShiftCountRule.create!(valid_attributes) }

  before(:each) do
    Section.stub!(:find).with(mock_section.id, anything) { mock_section }
    ShiftTag.stub!(:find).with(mock_shift_tag.id, anything) { mock_shift_tag }
  end

  subject { rule }

  # database
  
  it { should have_db_column(:section_id).with_options(:null => false) }

  it { should have_db_column(:shift_tag_id).with_options(:null => false) }

  it { should have_db_index(:section_id) }

  it { should have_db_index(:shift_tag_id).unique(true) }

  # associations

  it { should belong_to(:section) }

  it { should belong_to(:shift_tag) }

  # validations

  it { should validate_presence_of(:shift_tag) }

  it { should validate_associated(:section) }

  it { should validate_associated(:shift_tag) }

  it { should validate_uniqueness_of(:shift_tag_id) }

  it { should validate_numericality_of(:maximum) }

  it { should allow_value(nil).for(:maximum) }

  it { should allow_value(10).for(:maximum) }

  it { should_not allow_value(-1).for(:maximum) }

  it { should_not allow_value(100).for(:maximum) }

  # methods

  describe "#process(:assignments_by_physician_id)" do

    it "returns physicians over the daily maximum count in the tag" do
      shift_id = 0
      date = Date.civil(2011, 1, 1)
      mock_shift_tag = stub_model(ShiftTag)
      mock_shift_tag.stub(:shift_ids).and_return([shift_id])
      rule.update_attribute(:maximum, 0)
      rule.stub(:shift_tag).and_return(mock_shift_tag)
      mock_physician = stub_model(Physician)
      mock_assignment = stub_model(Assignment, :shift_id => shift_id,
        :date => date)
      rule.process({ mock_physician.id => [mock_assignment] }).
        should eq([
          {
            :physician_id => mock_physician.id,
            :description => "1 on Sat 1/1"
          }
        ])
    end
  end

  describe "#to_json" do

    it "returns valid json" do
      expect { JSON.parse(rule.to_json) }.to_not raise_error(JSON::ParserError)
    end
  end
end
