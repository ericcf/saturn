require 'spec_helper'

describe DailyShiftCountRule do

  before(:each) do
    mock_section = stub_model(Section, :valid? => true)
    Section.stub!(:find).with(mock_section.id, anything).
      and_return(mock_section)
    mock_shift_tag = stub_model(ShiftTag, :valid? => true)
    ShiftTag.stub!(:find).with(mock_shift_tag.id, anything).
      and_return(mock_shift_tag)
    @valid_attributes = {
      :section => mock_section,
      :shift_tag => mock_shift_tag
    }
    @rule = DailyShiftCountRule.create(@valid_attributes)
    @rule.should be_valid
  end

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
end
