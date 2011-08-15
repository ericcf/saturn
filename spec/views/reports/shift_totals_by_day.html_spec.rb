require 'spec_helper'

describe "reports/shift_totals_by_day.html.haml" do

  let(:mock_section) { stub_model(Section) }
  let(:mock_shift) { stub_model(Shift, :title => "Conference") }
  let(:mock_physician) do
    mock_model(Physician, :initials => "QQ", :full_name => "Q Q")
  end
  let(:mock_report) do
    stub_model(::Logical::ShiftTotalsReport, :start_date => "2010-05-05",
      :end_date => "2010-06-01",
      :physicians_by_group => { "Residents" => [mock_physician] },
      :section => mock_section)
  end

  before(:each) do
    assign(:section, mock_section)
    assign(:shift, mock_shift)
    assign(:shift_totals_report, mock_report)
    view.stub!(:nav_item)
    render
  end

  subject { rendered }

  it "displays a header containing the shift title and date range" do
    should have_selector("h3",
      :content => "Daily Totals for Conference, 5 May 2010 - 1 June 2010")
  end

  it "displays each group followed by its members in the header" do
    should have_selector("table thead tr") do |header_row|
      header_row.should have_selector("th", :content => "Residents")
      header_row.should have_selector("th", :content => mock_physician.initials)
    end
  end
end
