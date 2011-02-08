require 'spec_helper'

describe ShiftWeekNote do

  let(:mock_shift) { stub_model(Shift, :valid? => true) }
  let(:mock_weekly_schedule) { stub_model(WeeklySchedule, :valid? => true) }
  let(:valid_attributes) do
    Shift.stub!(:find).with(mock_shift.id, anything) { mock_shift }
    WeeklySchedule.stub!(:find).with(mock_weekly_schedule.id, anything) { mock_weekly_schedule }
    {
      :shift => mock_shift,
      :weekly_schedule => mock_weekly_schedule,
      :text => "Lorem ipsum..."
    }
  end
  let(:shift_week_note) { ShiftWeekNote.create!(valid_attributes) }

  # database

  it { should have_db_column(:shift_id).with_options(:null => false) }

  it { should have_db_column(:weekly_schedule_id).with_options(:null => false) }

  it { should have_db_column(:text).with_options(:null => false) }

  it { should have_db_index([:shift_id, :weekly_schedule_id]).unique(true) }

  # associations

  it { should belong_to(:shift) }

  it { should belong_to(:weekly_schedule) }

  # validations

  it { should validate_presence_of(:shift) }

  it { should validate_presence_of(:weekly_schedule) }

  it { should validate_presence_of(:text) }

  it { should validate_associated(:shift) }
end
