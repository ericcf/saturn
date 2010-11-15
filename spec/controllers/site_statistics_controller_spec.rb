require 'spec_helper'

describe SiteStatisticsController do

  describe "GET index" do

    before(:each) do
      @now = DateTime.now
      @assignment_count = 5
      Assignment.stub!(:count).and_return(@assignment_count)
      @mock_assignment = stub_model(Assignment)
      Assignment.stub_chain("order.limit").and_return([@mock_assignment])
      @section_count = 6
      Section.stub!(:count).and_return(@section_count)
      @mock_section = stub_model(Section)
      Section.stub!(:order).and_return([@mock_section])
      get :index
    end

    it { assigns(:assignment_count).should == @assignment_count }

    it { assigns(:recent_assignments).should == [@mock_assignment] }

    it { assigns(:section_count).should == @section_count }

    it { assigns(:sections).should == [@mock_section] }
  end
end
