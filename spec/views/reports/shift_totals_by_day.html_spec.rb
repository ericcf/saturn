require 'spec_helper'

describe "reports/shift_totals_by_day.html.haml" do

  let(:mock_section) { stub_model(Section) }

  let(:mock_shift) { stub_model(Shift, :title => "Conference") }

  let(:mock_physician) { stub_model(Physician, :initials => "QQ") }

  let(:mock_group) { stub_model(RadDirectory::Group, :title => "Fellows") }

  let(:mock_report) do
    stub_model(ShiftTotalsReport, :start_date => "2010-05-05",
      :end_date => "2010-06-01",
      :physicians_by_group => { mock_group => [mock_physician] },
      :section => mock_section)
  end

  before(:each) do
    assign(:section, mock_section)
    assign(:shift, mock_shift)
    assign(:shift_totals_report, mock_report)
    view.stub!(:nav_item)
    render
  end

  it "displays a header containing the shift title and date range" do
    rendered.should have_selector("h3",
      :content => "Daily Totals for Conference, 5 May 2010 - 1 June 2010")
  end

  it "displays each group followed by its members in the header" do
    rendered.should have_selector("table thead tr") do |header_row|
      header_row.should have_selector("th", :content => mock_group.title)
      header_row.should have_selector("th", :content => mock_physician.initials)
    end
  end
end
