require 'spec_helper'

describe "physicians/_weekly_schedule" do

  before(:each) do
    @mock_physician = stub_model(Physician)
    @mock_physician.stub!(:full_name).with(:family_first).and_return("Bar, Foo")
    view.should_receive(:weekly_schedule).any_number_of_times.
      and_return({ :physician => @mock_physician, :daily_shifts => [] })
    render
  end

  it "renders a table row with a cell containing the physician's name" do
    rendered.should have_selector("tr td a",
      :href => schedule_physician_path(@mock_physician),
      :content => "Bar, Foo")
  end
end
