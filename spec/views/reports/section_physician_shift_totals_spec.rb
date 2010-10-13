require 'spec_helper'

describe "reports/section_physician_shift_totals" do

  before(:each) do
    assign(:physician, mock_model(Physician).as_null_object)
    assign(:section, mock_model(Section))
    assign(:shifts, [])
    @start_date = assign(:start_date, Date.today)
    @end_date = assign(:end_date, Date.tomorrow)
    should_render_partial("schedules/section_menu")
    render
  end

  it "renders the start and end dates of the reporting period" do
    rendered.should have_selector("span#start_date_text",
      :content => @start_date.to_s(:long))
    rendered.should have_selector("span#end_date_text",
      :content => @end_date.to_s(:long))
  end
end
