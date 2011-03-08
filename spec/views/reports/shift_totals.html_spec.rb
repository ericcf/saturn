require 'spec_helper'

describe "reports/shift_totals.html" do

  let(:start_date) { Date.today }
  let(:end_date) { Date.tomorrow }

  before(:each) do
    assign(:section, mock_model(Section, :title => "My Section"))
    assign(:physicians_by_group, {})
    assign(:shifts, [])
    assign(:shift_tags, [])
    assign(:start_date, start_date)
    assign(:end_date, end_date)
    render
  end

  subject { rendered }

  it "renders the start and end dates of the reporting period" do
    should have_selector("span#start_date_text",
      :content => start_date.to_s(:long)
    )
    should have_selector("span#end_date_text",
      :content => end_date.to_s(:long)
    )
  end
end
