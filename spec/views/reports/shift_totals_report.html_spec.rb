require 'spec_helper'

describe "reports/shift_totals_report.html.haml" do

  let(:mock_section) { stub_model(Section) }
  let(:mock_physician) do
    stub_model(Physician, :initials => "AA", :full_name => "A A")
  end
  let(:mock_group) { stub("group", :id => 1, :title => "Jets") }
  let(:mock_report) do
    stub_model(::Logical::ShiftTotalsReport, :start_date => "2010-01-02",
      :end_date => "2010-03-04",
      :physicians_by_group => { mock_group => [mock_physician] },
      :groups => [mock_group.title])
  end

  before(:each) do
    assign(:section, mock_section)
    assign(:shift_totals_report, mock_report)
    view.stub!(:nav_item)
    render
  end

  subject { rendered }

  it "displays a header including the date range in the query" do
    should have_selector("h3",
      :content => "Report for 2 January 2010 - 4 March 2010")
  end

  it "displays each group followed by its members in the header" do
    should have_selector("table thead tr") do |header_row|
      header_row.should have_selector("th", :content => mock_group.title)
      header_row.should have_selector("th", :content => mock_physician.initials)
    end
  end
end
