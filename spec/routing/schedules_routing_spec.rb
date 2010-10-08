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

    it "recognizes and generates #edit_weekly_section for a date" do
      { :get => "/sections/1/schedule/2010/8/1/edit" }.
        should route_to(:controller => "schedules", :action => "edit_weekly_section", :section_id => "1", :year => "2010", :month => "8", :day => "1")
    end

    it "recognizes and generates #create_weekly_section" do
      { :post => "/sections/1/schedule" }.
        should route_to(:controller => "schedules", :action => "create_weekly_section", :section_id => "1")
    end

    it "recognizes and generates #update_weekly_section" do
      { :put => "/sections/1/schedule" }.
        should route_to(:controller => "schedules", :action => "update_weekly_section", :section_id => "1")
    end
  end
end
