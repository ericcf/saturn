require 'spec_helper'

describe SectionCallSchedulesController do

  describe "GET index.json" do

    before(:each) do
      @mock_call_schedule = mock_model(::Logical::SectionCallSchedule,
        :as_json => "call json")
      ::Logical::SectionCallSchedule.stub!(:new) { @mock_call_schedule }
      mock_section = mock_model(Section)
      Section.stub!(:all) { [mock_section] }
      get :index, :format => :json
    end

    it { response.body.should eq([@mock_call_schedule].to_json) }
  end
end
