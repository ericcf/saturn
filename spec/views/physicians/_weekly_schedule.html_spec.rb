require 'spec_helper'

describe "physicians/_weekly_schedule.html" do

  before(:each) do
    @mock_physician = stub_model(Physician)
    @mock_physician.stub!(:full_name).with(:family_first).and_return("Bar, Foo")
    weekly_schedule = { :physician => @mock_physician, :daily_shifts => [] }
    render :partial => "physicians/weekly_schedule.html",
      :locals => { :weekly_schedule_counter => 1, :weekly_schedule => weekly_schedule }
  end

  it "renders a table row with a cell containing the physician's name" do
    rendered.should have_selector("tr th a",
      :href => schedule_physician_path(@mock_physician),
      :content => "Bar, Foo")
  end
end
