require 'spec_helper'

describe "schedules/_shift" do

  before(:each) do
    Section.delete_all
    Shift.delete_all
    @shift = Factory(:shift)
    view.stub!(:shift).and_return(@shift)
    view.stub!(:mapped_assignments)
    view.stub!(:people_names)
    assign(:week_dates, [])
  end

  it "renders the shift row" do
    render
    rendered.should have_selector("tr#shift_#{@shift.id}")
  end
end
