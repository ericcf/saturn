require 'spec_helper'

describe "schedules/_schedule_cell.html" do

  before(:each) do
    render :partial => "schedules/schedule_cell.html",
      :locals => { :schedule_cell => nil }
  end

  subject { rendered }

  it { should have_selector("td") }
end
