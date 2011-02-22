require 'spec_helper'

describe SchedulesController do

  describe "routing" do

    it "recognizes and generates #weekly_call" do
      { :get => "/schedules/call" }.
        should route_to(:controller => "schedules", :action => "weekly_call") 
    end

    it "recognizes and generates #show_weekly_section" do
      { :get => "/sections/1/schedule" }.
        should route_to(:controller => "schedules", :action => "show_weekly_section", :section_id => "1")
    end
  end
end
