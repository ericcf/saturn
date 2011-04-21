require 'spec_helper'

describe SectionCallSchedulesController do

  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/section_call_schedules.json" }.
        should route_to(:controller => "section_call_schedules", :action => "index", :format => "json") 
    end
  end
end
