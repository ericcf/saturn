require 'spec_helper'

describe "sections/_mini_calendar_week_row.html" do

  let(:today) { Date.today }
  let(:mock_section) { mock_model(Section) }
  let(:mock_schedule) do
    mock_model(WeeklySchedule,
      :section_id => mock_section.id,
      :date => today,
      :dates => [today],
      :is_published => false
    )
  end

  before(:each) do
    view.stub!(:print_padded_days).with(mock_schedule.dates) { "padded days" }
    render :partial => "sections/mini_calendar_week_row",
      :locals => { :schedule => mock_schedule }
  end

  subject { rendered }

  it "renders a link to the schedule" do
    date_params = { :year => today.year, :month => today.month, :day => today.day }
    should have_selector("a",
      :href => weekly_section_schedule_path(mock_section.id, :date => date_params)
    )
  end
end
