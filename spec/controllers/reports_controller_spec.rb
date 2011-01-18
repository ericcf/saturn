require 'spec_helper'

describe ReportsController do

  def mock_section(stubs={})
    (@mock_section ||= stub_model(Section)).tap do |section|
      section.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET shift_totals" do

    before(:each) do
      mock_physician = stub_model(Physician)
      mock_shift = stub_model(Shift)
      Shift.stub!(:find).and_return([mock_shift])
      mock_section(:members_by_group => {"Group A" => [mock_physician]},
        :shift_tags => [stub_model(ShiftTag, :shift_ids => [mock_shift.id])])
      mock_section.stub_chain(:shifts, :active_as_of).and_return([mock_shift])
      Section.stub!(:find).with(mock_section.id).and_return(mock_section)
      mock_section.
        stub_chain(:assignments, :published, :date_in_range, :includes).
        and_return([stub_model(Assignment, :fixed_duration => 0.0, :physician_id => mock_physician.id, :shift_id => mock_shift.id)])
    end

    context "always" do

      before(:each) do
        get :shift_totals, :section_id => mock_section.id
      end

      it { assigns(:start_date).should == Date.today.at_beginning_of_month }

      it { assigns(:end_date).should == Date.today }
    end
  end

  describe "GET section_physician_shift_totals" do

    before(:each) do
      Section.stub!(:find).with(mock_section.id).and_return(mock_section)
      @mock_physician = mock_model(Physician)
      mock_section.stub_chain("members.find").and_return(@mock_physician)
      get :section_physician_shift_totals, :section_id => mock_section.id,
        :physician_id => @mock_physician.id
    end

    it { assigns(:start_date).should == Date.today.at_beginning_of_month }
  end
end
