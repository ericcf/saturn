require 'spec_helper'

describe "physicians/_daily_shifts.html" do

  let(:mock_shift) { mock("shift", :title => "Shift 1") }

  before(:each) do
    render :partial => "physicians/daily_shifts.html",
      :locals => { :daily_shifts => { :shifts => [mock_shift] } }
  end

  subject { rendered }

  it { should have_selector("td", :content => mock_shift.title) }
end
