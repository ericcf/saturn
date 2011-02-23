require 'spec_helper'

describe "schedules/weekly_call.html" do

  let(:mock_section) { stub_model(Section, :title => "Section A") }
  let(:mock_physician) { stub_model(Physician, :short_name => "L. Effant") }
  let(:mock_shifts) do
    [
      mock_model(Shift, :title => "Shift A", :section => mock_section),
      mock_model(Shift, :title => "Shift B", :section => mock_section)
    ]
  end
  let(:dates) { [Date.today, Date.tomorrow] }
  let(:mock_assignment) do
    stub_model(Assignment,
      :physician_id => mock_physician.id,
      :shift_id => mock_shifts.first.id,
      :date => dates.first
    )
  end
  let(:mock_presenter) do
    stub_model(CallSchedulePresenter, :dates => dates, :shifts => mock_shifts)
  end

  before(:each) do
    assign(:schedule_presenter, mock_presenter)
    render
  end

  subject { rendered }

  it "renders first of mock_presenter.dates" do
    should have_selector("h3",
      :content => "Week of #{mock_presenter.dates.first.to_s(:long)}"
    )
  end

  it "renders a table with headers labeled by date from mock_presenter.dates" do
    should have_selector("table") do |table|
      table.should have_selector("tr") do |tr|
        tr.should have_selector("th", :content => mock_presenter.dates.first.to_s(:short_with_weekday))
        tr.should have_selector("th", :content => mock_presenter.dates.second.to_s(:short_with_weekday))
      end
    end
  end

  it "renders the call shift titles on the rows from @call_shifts" do
    should have_selector("table") do |table|
      table.should have_selector("tr > th", :content => mock_presenter.shifts.first.title)
      table.should have_selector("tr > th", :content => mock_presenter.shifts.second.title)
    end
  end

  it "renders the assignments corresponding to the shifts and dates" do
    should have_selector("table") do |table|
      table.should have_selector("tr > td",
        :content => mock_physician.short_name
      )
    end
  end
end
