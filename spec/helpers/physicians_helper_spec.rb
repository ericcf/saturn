require 'spec_helper'

describe PhysiciansHelper do

  describe "#physicians_weekly_schedules(:physicians, :dates, :assignments)" do

    def week_dates
      (Date.today..Date.today+6.days).entries
    end

    it "returns an empty list with no physicians" do
      helper.physicians_weekly_schedules([], week_dates, []).should == []
    end

    it "assigns an empty list to shifts for days with no assignments" do
      mock_physician = stub_model(Physician)
      helper.physicians_weekly_schedules([mock_physician], week_dates, []).
        should == [{
          :physician => mock_physician,
          :daily_shifts => week_dates.map { |date| { :date => date, :shifts => [] } }
        }]
    end

    it "assigns shifts to days with assignments" do
      mock_physician = stub_model(Physician)
      mock_shift = stub_model(Shift)
      mock_assignment = stub_model(Assignment, :shift => mock_shift,
        :date => week_dates.first, :physician_id => mock_physician.id)
      helper.physicians_weekly_schedules([mock_physician], week_dates, [mock_assignment]).first[:daily_shifts].first[:shifts].first.
        should == mock_shift
    end
  end
end
