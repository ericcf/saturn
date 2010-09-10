require 'spec_helper'

describe PeopleController do

  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/people" }.
        should route_to(:controller => "people", :action => "index") 
    end

    it "recognizes and generates #show" do
      { :get => "/people/1" }.
        should route_to(:controller => "people", :action => "show", :id => "1") 
    end

    it "does not recognize #create" do
      { :post => "/people" }.should_not be_routable
    end

    it "recognizes and generates #edit" do
      { :get => "/people/1/edit" }.
        should route_to(:controller => "people", :action => "edit", :id => "1") 
    end

    it "recognizes and generates #update" do
      { :put => "/people/1" }.
        should route_to(:controller => "people", :action => "update", :id => "1") 
    end

    it "does not recognize #destroy" do
      { :delete => "/people/1" }.should_not be_routable
    end

    it "recognizes and generates #schedule" do
      { :get => "/people/1/schedule" }.
        should route_to(:controller => "people", :action => "schedule", :id => "1")
    end
  end
end
