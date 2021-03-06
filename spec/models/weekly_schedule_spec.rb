require 'spec_helper'

describe WeeklySchedule do

  let(:mock_section) { stub_model(Section) }
  let(:monday) { Date.today.at_beginning_of_week }
  let(:valid_attributes) do
    {
      :section_id => mock_section.id,
      :date => monday
    }
  end
  let(:weekly_schedule) { WeeklySchedule.create!(valid_attributes) }

  before(:each) do
    Section.stub!(:find).with(mock_section.id, anything).
      and_return(mock_section)
  end

  subject { weekly_schedule }

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

  # scopes

  describe "#include_dates" do

    it "returns schedules that include the dates" do
      WeeklySchedule.include_dates([weekly_schedule.date]).
        should include(weekly_schedule)
    end

    it "does not return schedules that do not include the dates" do
      WeeklySchedule.include_dates([weekly_schedule.date - 1.year]).
        should_not include(weekly_schedule)
    end
  end

  describe "#by_year" do

    it "returns schedules that begin on the calendar year" do
      WeeklySchedule.by_year(weekly_schedule.date.year).
        should include(weekly_schedule)
    end

    it "does not return schedules that do not begin on the calendar year" do
      WeeklySchedule.by_year(weekly_schedule.date.year - 1).
        should_not include(weekly_schedule)
    end
  end

  # methods
  
  describe "#shift_weeks_json" do

    it "serializes the object as valid json" do
      expect { JSON.parse(weekly_schedule.to_json) }.
        to_not raise_error(JSON::ParserError)
    end
  end
end
