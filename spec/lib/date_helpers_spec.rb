require 'spec_helper'

class NoDateSupport; include DateHelpers; end

describe DateHelpers do

  before(:each) do
    @test_object = NoDateSupport.new
  end

  describe "#monday_of_week_with(:date)" do

    context "when date can be parsed" do

      it "returns the monday of the week including date" do
        date = "2020-1-1"
        @test_object.monday_of_week_with(date).
          should == Date.parse(date).at_beginning_of_week
      end
    end

    context "when date cannot be parsed" do

      it "returns the monday of the current week" do
        date = "Foobar"
        @test_object.monday_of_week_with(date).
          should == Date.today.at_beginning_of_week
      end
    end
  end

  describe "#week_dates_beginning_with(:date)" do

    it "returns the requested date and the following 6 days" do
      date = Date.today
      days = @test_object.week_dates_beginning_with(date)
      days.size.should == 7
      days[0].should == date
      days[6].should == date+6
    end
  end
end
