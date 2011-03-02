require 'spec_helper'

describe "schedules/_date_header.html" do

  let(:today) do
    @today = Date.today
    Date.stub!(:today) { @today }
    @today
  end

  before(:each) do
    render "schedules/date_header", :date => today
  end

  subject { rendered }

  it { should have_selector("th.current-date", :content => today.to_s(:short_with_weekday)) }
end
