require 'spec_helper'

describe ShiftsController do

  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/sections/1/shifts" }.
        should route_to(:controller => "shifts", :action => "index", :section_id => "1") 
    end

    it "recognizes and generates #new" do
      { :get => "/sections/1/shifts/new" }.
        should route_to(:controller => "shifts", :action => "new", :section_id => "1") 
    end

    it "recognizes and generates #create" do
      { :post => "/sections/1/shifts" }.
        should route_to(:controller => "shifts", :action => "create", :section_id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/sections/1/shifts/2" }.
        should route_to(:controller => "shifts", :action => "destroy", :section_id => "1", :id => "2") 
    end
  end
end
