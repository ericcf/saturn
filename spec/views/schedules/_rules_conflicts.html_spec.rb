require 'spec_helper'

describe "schedules/_rules_conflicts.html" do

  let(:mock_schedule) { stub_model(WeeklySchedule) }

  before(:each) do
    render :partial => "schedules/rules_conflicts.html",
      :locals => {
        :assignments => nil,
        :schedule => mock_schedule,
        :physician_names_by_id => {}
      }
  end

  subject { rendered }
end
