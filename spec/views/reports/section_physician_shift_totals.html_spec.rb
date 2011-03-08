require 'spec_helper'

describe "reports/section_physician_shift_totals.html" do

  let(:start_date) { Date.today }
  let(:end_date) { Date.tomorrow }

  before(:each) do
    assign(:physician, mock_model(Physician).as_null_object)
    assign(:section, mock_model(Section))
    assign(:shifts, [])
    assign(:start_date, start_date)
    assign(:end_date, end_date)
    render
  end

  subject { rendered }

  it "renders the start and end dates of the reporting period" do
    should have_selector("span#start_date_text",
      :content => start_date.to_s(:long))
    should have_selector("span#end_date_text",
      :content => end_date.to_s(:long))
  end
end
