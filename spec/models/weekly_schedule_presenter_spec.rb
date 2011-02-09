require 'spec_helper'

describe WeeklySchedulePresenter do

  let(:mock_weekly_schedule) { stub_model(WeeklySchedule) }
  let(:mock_physician) { stub_model(Physician, :short_name => "S. Gonzalez") }
  let(:mock_physician_name_by_id) { { mock_physician.id => mock_physician.short_name } }

  before(:each) do
    @mock_section = stub_model(Section)
    @dates = [Date.yesterday, Date.today]
    mock_shift = stub_model(Shift, :title => "Conference")
    @mock_assignments = [
      stub_model(Assignment, :shift => mock_shift, :physician_id => mock_physician.id),
      stub_model(Assignment, :shift => mock_shift, :physician_id => mock_physician.id)
    ]
  end

  it "passes a smoke test" do
    WeeklySchedulePresenter.new(:section => @mock_section, :dates => @dates,
      :assignments => @mock_assignments, :weekly_schedule => mock_weekly_schedule,
      :physician_names_by_id => mock_physician_name_by_id,
      :options => { :col_type => :dates, :row_type => :shifts })
    WeeklySchedulePresenter.new(:section => @mock_section, :dates => @dates,
      :assignments => @mock_assignments, :weekly_schedule => mock_weekly_schedule,
      :physician_names_by_id => mock_physician_name_by_id,
      :options => { :col_type => :dates, :row_type => :physicians })
  end
end
