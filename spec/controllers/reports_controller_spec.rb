require 'spec_helper'

describe ReportsController do

  before(:each) do
    @mock_section = mock_model(Section)
    Section.stub!(:find).with(@mock_section.id).and_return(@mock_section)
  end

  describe "GET shift_totals" do

    before(:each) do
      grouped_people = mock("grouped people")
      @mock_section.stub!(:members_by_group).and_return(grouped_people)
      mock_shifts = Array.new
      @mock_section.stub_chain(:shifts, :active_as_of).and_return(mock_shifts)
      mock_shift_tags = Array.new
      @mock_section.stub!(:shift_tags).and_return(mock_shift_tags)
      mock_assignments = mock("assignments")
      Assignment.stub_chain(:date_in_range, :find_all_by_shift_id).
        and_return(mock_assignments)
      @mock_report = mock("report")
      ShiftsReport.should_receive(:new).with(mock_assignments, mock_shifts,
        mock_shift_tags, grouped_people).and_return(@mock_report)
      get :shift_totals, :section_id => @mock_section.id
    end

    it { assigns(:start_date).should == Date.today.at_beginning_of_month }

    it { assigns(:end_date).should == Date.today }

    it { assigns(:report).should == @mock_report }
  end
end
