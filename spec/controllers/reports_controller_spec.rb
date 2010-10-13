require 'spec_helper'

describe ReportsController do

  def mock_section(stubs={})
    @mock_section ||= stub_model(Section, stubs)
  end

  describe "GET shift_totals" do

    before(:each) do
      Section.stub!(:find).with(mock_section.id).and_return(mock_section)
      mock_section.stub!(:members_by_group).and_return({})
      mock_shifts = Array.new
      mock_section.stub_chain(:shifts, :active_as_of).and_return(mock_shifts)
      mock_shift_tags = Array.new
      mock_section.stub!(:shift_tags).and_return(mock_shift_tags)
      mock_section.
        stub_chain(:assignments, :published, :date_in_range, :includes).
        and_return([stub_model(Assignment, :fixed_duration => 0.0)])
      get :shift_totals, :section_id => mock_section.id
    end

    it { assigns(:start_date).should == Date.today.at_beginning_of_month }

    it { assigns(:end_date).should == Date.today }
  end

  describe "GET section_physician_shift_totals" do

    before(:each) do
      Section.stub!(:find).with(mock_section.id).and_return(mock_section)
      @mock_physician = mock_model(Physician)
      mock_section.stub_chain(:memberships, :find_by_physician_id, :physician).
        and_return(@mock_physician)
      get :section_physician_shift_totals, :section_id => mock_section.id,
        :physician_id => @mock_physician.id
    end

    it { assigns(:start_date).should == Date.today.at_beginning_of_month }
  end
end
