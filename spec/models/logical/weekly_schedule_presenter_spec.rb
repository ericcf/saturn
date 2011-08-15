require 'spec_helper'

describe ::Logical::WeeklySchedulePresenter do

  let(:mock_shift) { stub_model(Shift) }
  let(:mock_section_shift) do
    stub_model(SectionShift, :shift_id => mock_shift.id)
  end
  let(:mock_pending_assignment_requests) { [] }
  let(:mock_weekly_schedule) do
    stub_model(WeeklySchedule, :shifts => [mock_shift]).tap do |s|
      s.stub_chain("assignment_requests.pending").
        and_return(mock_pending_assignment_requests)
    end
  end
  let(:mock_physician_a) do
    mock_model(Physician, :short_name => "Y. Sam")
  end
  let(:mock_physician_b) do
    mock_model(Physician, :short_name => "B. Bunny")
  end
  let(:physician_names_by_id) do
    {
      mock_physician_a.id => mock_physician_a.short_name,
      mock_physician_b.id => mock_physician_b.short_name
    }
  end
  let(:mock_section) do
    mock_model(Section, :shifts => [mock_shift], :section_shifts => [mock_section_shift], :members_by_group => { "Faculty" => [mock_physician_a, mock_physician_b] })
  end
  let(:mock_assignments) do
    [
      stub_model(Assignment, :shift => mock_shift, :physician => mock_physician_a),
      stub_model(Assignment, :shift => mock_shift, :physician => mock_physician_b)
    ]
  end
  let(:dates) { [Date.yesterday, Date.today] }

  describe "in view mode 1 (dates in columns, shifts in rows" do

    it "should have as many rows as shifts" do
      ::Logical::WeeklySchedulePresenter.new(
        :section => mock_section,
        :dates => dates,
        :assignments => mock_assignments,
        :weekly_schedule => mock_weekly_schedule,
        :physician_names_by_id => physician_names_by_id,
        :options => { :col_type => :dates, :row_type => :shifts }
      ).rows.count.should eq(1)
    end
  end
  
  describe "in view mode 2 (dates in columns, people in rows)" do

    it "should have as many rows as people" do
      ::Logical::WeeklySchedulePresenter.new(
        :section => mock_section,
        :dates => dates,
        :assignments => mock_assignments,
        :weekly_schedule => mock_weekly_schedule,
        :physician_names_by_id => physician_names_by_id,
        :options => { :col_type => :dates, :row_type => :physicians }
      ).rows.count.should eq(2)
    end
  end
end
