require 'spec_helper'

describe MeetingShiftsController do

  describe "routing" do

    it "recognizes and generates #new" do
      { :get => "/sections/1/meeting_shifts/new" }.
        should route_to(:controller => "meeting_shifts", :action => "new", :section_id => "1") 
    end

    it "recognizes and generates #create" do
      { :post => "/sections/1/meeting_shifts" }.
        should route_to(:controller => "meeting_shifts", :action => "create", :section_id => "1") 
    end

    it "recognizes and generates #edit" do
      { :get => "/sections/1/meeting_shifts/2/edit" }.
        should route_to(:controller => "meeting_shifts", :action => "edit", :section_id => "1", :id => "2") 
    end

    it "recognizes and generates #update" do
      { :put => "/sections/1/meeting_shifts/2" }.
        should route_to(:controller => "meeting_shifts", :action => "update", :section_id => "1", :id => "2") 
    end
  end
end
