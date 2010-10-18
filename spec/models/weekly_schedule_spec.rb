require 'spec_helper'

describe WeeklySchedule do
  before(:each) do
    mock_section = mock_model(Section)
    Section.stub!(:find).with(mock_section.id, anything).
      and_return(mock_section)
    @valid_attributes = {
      :section_id => mock_section.id,
      :date => Date.today,
      :published_at => Time.now
    }
    @schedule = WeeklySchedule.create(@valid_attributes)
    @schedule.should be_valid
  end

  # database
  
  it { should have_db_column(:section_id).
    with_options(:null => false) }

  it { should have_db_index(:section_id) }

  it { should have_db_column(:date).with_options(:null => false) }

  it { should have_db_index(:date) }

  it { should have_db_index([:section_id, :date]).unique(true) }

  # associations

  it { should have_many(:assignments).dependent(:destroy) }

  it { should belong_to(:section) }

  # validations

  it { should validate_presence_of(:section) }

  it { should validate_presence_of(:date) }

  it { should validate_uniqueness_of(:date).scoped_to(:section_id) }

  # methods
  
  describe "#published?" do

    it "returns published_at!=nil" do
      @schedule.published_at = nil
      @schedule.published?.should be_false
      @schedule.published_at = Date.today
      @schedule.published?.should be_true
    end
  end
  
  describe "#publish=(:value)" do

    context "value is like true" do

      it "sets published_at" do
        @schedule.publish = "1"
        @schedule.published_at.should_not be_nil
      end
    end

    context "value is like false" do

      it "sets published_at to nil" do
        @schedule.publish = "0"
        @schedule.published_at.should be_nil
      end
    end
  end
end
