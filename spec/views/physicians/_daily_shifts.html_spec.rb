require 'spec_helper'

describe "physicians/_daily_shifts.html" do

  before(:each) do
    mock_shift = mock("shift", :title => "Shift 1")
    view.should_receive(:daily_shifts).
      and_return( { :shifts => [mock_shift] })
    render
  end

  it "renders a cell listing the daily assigned shifts" do
    rendered.should have_selector("td", :content => "Shift 1")
  end
end
