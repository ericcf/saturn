require 'spec_helper'

describe "reports/search_shift_totals.html.haml" do

  let(:mock_shift) { stub_model(Shift, :title => "Foo") }
  let(:mock_group) { stub_model(RadDirectory::Group, :title => "Bars") }
  let(:mock_section) { stub_model(Section) }
  let(:mock_report) { mock_model(ShiftTotalsReport, :start_date => nil, :end_date => nil, :shift_ids => [], :group_ids => []) }

  before(:each) do
    mock_section.stub!(:active_shifts) { [mock_shift] }
    assign(:section, mock_section)
    assign(:shift_totals_report, mock_report)
    view.stub!(:physician_groups) { [mock_group] }
    view.stub!(:nav_item)
    render
  end

  subject { rendered }

  it "displays a form which submits to shift_totals_report" do
    should have_selector("form",
      :action => shift_totals_report_section_reports_path(mock_section),
      :method => "post")
  end

  it "displays a label and text field for the start_date" do
    should have_selector("form label", :for => "shift_totals_report_start_date",
      :content => "From")
    should have_selector("form input", :name => "shift_totals_report[start_date]")
  end

  it "displays a label and text field for the end_date" do
    should have_selector("form label", :for => "shift_totals_report_end_date",
      :content => "To")
    should have_selector("form input", :name => "shift_totals_report[end_date]")
  end

  it "displays a fieldset and check boxes for selecting shifts" do
    should have_selector("form fieldset legend", :content => "Shifts")
    should have_selector("form input", :name => "shift_totals_report[shift_ids][]",
      :value => "#{mock_shift.id}")
  end

  it "displays a fieldset and check boxes for selecting physician groups" do
    should have_selector("form fieldset legend", :content => "Groups")
    should have_selector("form input", :name => "shift_totals_report[group_ids][]",
      :value => "#{mock_group.id}")
  end

  it "dispalys a submit button" do
    should have_selector("form input", :type => "submit",
      :value => "Generate Report")
  end
end
