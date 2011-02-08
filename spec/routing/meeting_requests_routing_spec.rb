require 'spec_helper'

describe MeetingRequestsController do

  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/sections/1/meeting_requests" }.
        should route_to(:controller => "meeting_requests", :action => "index", :section_id => "1") 
    end

    it "recognizes and generates #show" do
      { :get => "/sections/1/meeting_requests/2" }.
        should route_to(:controller => "meeting_requests", :action => "show", :section_id => "1", :id => "2") 
    end

    it "recognizes and generates #new" do
      { :get => "/sections/1/meeting_requests/new" }.
        should route_to(:controller => "meeting_requests", :action => "new", :section_id => "1") 
    end

    it "recognizes and generates #create" do
      { :post => "/sections/1/meeting_requests" }.
        should route_to(:controller => "meeting_requests", :action => "create", :section_id => "1") 
    end

    it "recognizes and generates #edit" do
      { :get => "/sections/1/meeting_requests/2/edit" }.
        should route_to(:controller => "meeting_requests", :action => "edit", :section_id => "1", :id => "2") 
    end

    it "recognizes and generates #update" do
      { :put => "/sections/1/meeting_requests/2" }.
        should route_to(:controller => "meeting_requests", :action => "update", :section_id => "1", :id => "2") 
    end

    it "recognizes and generates #approve" do
      { :post => "/sections/1/meeting_requests/2/approve" }.
        should route_to(:controller => "meeting_requests", :action => "approve", :section_id => "1", :id => "2") 
    end
  end
end
