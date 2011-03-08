require 'spec_helper'

describe ApplicationHelper do

  describe "#holiday_title_on(:date)" do

    let(:today) { Date.today }

    it "returns the title of the holiday on the given date" do
      easter = Holiday.create!(:date => today, :title => "Easter")
      helper.holiday_title_on(today).should eq("Easter")
    end
  end
end
