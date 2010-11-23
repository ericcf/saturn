require 'spec_helper'

describe "schedules/weekly_call" do

  before(:each) do
    today, tomorrow = Date.today, Date.tomorrow
    @dates = assign(:dates, [today, tomorrow])
    view.stub!(:short_date).with(today) { today.to_s }
    view.stub!(:short_date).with(tomorrow) { tomorrow.to_s }
    mock_section = stub_model(Section, :title => "Section A")
    @call_shifts = assign(:call_shifts, [
      mock_model(Shift, :title => "Shift A", :section => mock_section),
      mock_model(Shift, :title => "Shift B", :section => mock_section)
    ])
    assign(:call_assignments, [])
  end

  it "renders first of @dates" do
    render
    rendered.should have_selector("h3",
      :content => "Week of #{@dates.first.to_s(:long)}"
    )
  end

  it "renders a table with headers labeled by date from @dates" do
    render
    rendered.should have_selector("table") do |table|
      table.should have_selector("tr") do |tr|
        tr.should have_selector("th", :content => @dates.first.to_s)
        tr.should have_selector("th", :content => @dates.second.to_s)
      end
    end
  end

  it "renders the call shift titles on the rows from @call_shifts" do
    render
    rendered.should have_selector("table") do |table|
      table.should have_selector("tr > th", :content => "Shift A")
      table.should have_selector("tr > th", :content => "Shift B")
    end
  end

  it "renders the assignments corresponding to the shifts and dates" do
    mock_physician = stub_model(Physician, :short_name => "L. Effant")
    assign(:physicians_by_id, { mock_physician.id => mock_physician })
    assign(:call_assignments, [
      mock_model(Assignment,
                 :physician_id => mock_physician.id,
                 :shift_id => @call_shifts.first.id,
                 :date => @dates.first)
    ])
    render
    rendered.should have_selector("table") do |table|
      table.should have_selector("tr > td",
        :content => mock_physician.short_name
      )
    end
  end
end
