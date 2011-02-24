require 'spec_helper'

describe "weekly_schedules/show.html" do

  let(:mock_weekly_schedule) do
    stub_model(WeeklySchedule, :date => "1234", :is_published => true)
  end
  let(:mock_section) { stub_model(Section) }

  before(:each) do
    assign(:weekly_schedules, [mock_weekly_schedule])
    assign(:section, mock_section)
    render
  end

  subject { rendered }

  it do
    should have_selector("ul li") do |item|
      item.should have_selector("a",
        :href => edit_section_weekly_schedules_path(mock_section),
        :content => mock_weekly_schedule.date
      )
      item.should contain("published")
    end
  end
end
