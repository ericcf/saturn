require 'spec_helper'

describe "sections/show.html" do

  let(:mock_section) { mock_model(Section) }
  let(:this_year) { Date.today.year }
  let(:mock_schedule) do
    mock_model(::Logical::YearlySectionSchedule,
      :year => this_year,
      :monthly_schedules => []
    )
  end

  before(:each) do
    assign(:section, mock_section)
    assign(:schedule, mock_schedule)
    render
  end

  subject { rendered }

  it "renders links to last and next year" do
    should have_selector("h3") do |header|
      header.should have_selector("a",
        :href => section_path(mock_section, :year => this_year - 1)
      )
      header.should have_selector("a",
        :href => section_path(mock_section, :year => this_year + 1)
      )
    end
  end
end
