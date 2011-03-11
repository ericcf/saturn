require 'spec_helper'

describe "schedules/show_weekly_section.html" do

  let(:mock_section) { stub_model(Section) }
  let(:dates) { [Date.today] }
  let(:mock_presenter) do
    stub_model(WeeklySchedulePresenter,
      :weekly_schedule => mock_model(WeeklySchedule),
      :each_col_header => nil,
      :rows => [],
      :dates => dates
    )
  end

  before(:each) do
    assign(:section, mock_section)
    assign(:schedule_presenter, mock_presenter)
    render
  end

  subject { rendered }

  it {
    should have_selector("form",
      :action => weekly_section_schedule_path(mock_section),
      :method => "get"
    )
  }

  it { should have_selector("form select", :name => "date[year]") }
  it { should have_selector("form select", :name => "date[month]") }
  it { should have_selector("form select", :name => "date[day]") }

  it {
    date = dates.first
    should have_selector("a",
      :href => weekly_section_schedule_path(mock_section, :format => :xls, :date => { :year => date.year, :month => date.month, :day => date.day }, :view_mode => nil),
      :content => "Download as Excel"
    )
  }

  it {
    should have_selector("table.schedule thead") do |table_head|
      table_head.should have_selector("th a", :content => "View by Physician")
    end
  }
end
