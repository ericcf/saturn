require 'spec_helper'

describe PhysiciansController do

  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/physicians" }.
        should route_to(:controller => "physicians", :action => "index") 
    end

    it "does not recognize #create" do
      { :post => "/physicians" }.should_not be_routable
    end

    it "does not recognize #edit" do
      { :get => "/physicians/1/edit" }.should_not be_routable
    end

    it "does not recognize #update" do
      { :put => "/physicians/1" }.should_not be_routable
    end

    it "does not recognize #destroy" do
      { :delete => "/physicians/1" }.should_not be_routable
    end

    it "recognizes and generates #search" do
      { :get => "/physicians/search" }.
        should route_to(:controller => "physicians", :action => "search")
    end

    it "recognizes and generates #schedule" do
      { :get => "/physicians/1/schedule" }.
        should route_to(:controller => "physicians", :action => "schedule", :id => "1")
    end
  end
end
