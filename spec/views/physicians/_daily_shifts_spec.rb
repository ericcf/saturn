require 'spec_helper'

describe "physicians/_daily_shifts" do

  before(:each) do
    mock_shift = mock("shift", :title => "Shift 1")
    view.should_receive(:daily_shifts).twice.
      and_return( { :date => Date.today, :shifts => [mock_shift] })
    render
  end

  it "renders a cell listing the daily assigned shifts" do
    rendered.should have_selector("td.current-date", :content => "Shift 1")
  end
end
