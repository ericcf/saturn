require 'spec_helper'

describe WeeklySchedule do
  before(:each) do
    mock_section = mock_model(Section)
    Section.stub!(:find).with(mock_section.id, anything).
      and_return(mock_section)
    @valid_attributes = {
      :section_id => mock_section.id,
      :date => Date.today
    }
    @schedule = WeeklySchedule.create(@valid_attributes)
    @schedule.should be_valid
  end

  # database
  
  it { should have_db_column(:section_id).with_options(:null => false) }

  it { should have_db_index(:section_id) }

  it { should have_db_column(:date).with_options(:null => false) }

  it { should have_db_index(:date) }

  it { should have_db_column(:is_published).with_options(:null => false, :default => false) }

  it { should have_db_index([:section_id, :date]).unique(true) }

  # associations

  it { should have_many(:shift_week_notes).dependent(:destroy) }

  it { should belong_to(:section) }

  # validations

  it { should validate_presence_of(:section) }

  it { should validate_presence_of(:date) }

  it { should validate_uniqueness_of(:date).scoped_to(:section_id) }

  # methods
  
  describe "#include_date(:date)" do

    it "returns schedules which include the specified date" do
      WeeklySchedule.include_date(@schedule.date).should include(@schedule)
      WeeklySchedule.include_date(@schedule.date + 6).should include(@schedule)
    end

    it "does not return schedules which do not include the specified date" do
      WeeklySchedule.include_date(@schedule.date - 1).
        should_not include(@schedule)
      WeeklySchedule.include_date(@schedule.date + 7).
        should_not include(@schedule)
    end
  end
end
