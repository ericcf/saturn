require 'spec_helper'

describe SiteStatisticsController do

  describe "GET index" do

    before(:each) do
      @now = DateTime.now
      @assignment_count = 5
      Assignment.stub!(:count).and_return(@assignment_count)
      Assignment.stub_chain(:order, :last, :updated_at).and_return(@now)
      @section_count = 6
      Section.stub!(:count).and_return(@section_count)
      Section.stub_chain(:order, :last, :updated_at).and_return(@now)
      get :index
    end

    it { assigns(:assignment_count).should == @assignment_count }

    it { assigns(:assignments_last_updated).should == @now }

    it { assigns(:section_count).should == @section_count }

    it { assigns(:sections_last_updated).should == @now }
  end
end
