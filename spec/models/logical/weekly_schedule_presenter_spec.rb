require 'spec_helper'

describe ::Logical::WeeklySchedulePresenter do

  let(:mock_section) { stub_model(Section) }
  let(:mock_shift) { stub_model(Shift) }
  let(:mock_weekly_schedule) { stub_model(WeeklySchedule) }
  let(:mock_physician) { stub_model(Physician, :short_name => "S. Gonzalez") }
  let(:mock_physician_name_by_id) do
    { mock_physician.id => mock_physician.short_name }
  end
  let(:mock_assignments) do
    [
      stub_model(Assignment, :shift => mock_shift, :physician => mock_physician),
      stub_model(Assignment, :shift => mock_shift, :physician => mock_physician)
    ]
  end
  let(:dates) { [Date.yesterday, Date.today] }

  it "passes a smoke test" do
    ::Logical::WeeklySchedulePresenter.new(:section => mock_section,
      :dates => dates,
      :assignments => mock_assignments,
      :weekly_schedule => mock_weekly_schedule,
      :physician_names_by_id => mock_physician_name_by_id,
      :options => { :col_type => :dates, :row_type => :shifts }
    )
    ::Logical::WeeklySchedulePresenter.new(:section => mock_section,
      :dates => dates,
      :assignments => mock_assignments,
      :weekly_schedule => mock_weekly_schedule,
      :physician_names_by_id => mock_physician_name_by_id,
      :options => { :col_type => :dates, :row_type => :physicians }
    )
  end
end
