require 'spec_helper'

describe RotationsController do

  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/rotations" }.
        should route_to(:controller => "rotations", :action => "index") 
    end

    it "recognizes and generates #new" do
      { :get => "/rotations/new" }.
        should route_to(:controller => "rotations", :action => "new") 
    end

    it "recognizes and generates #create" do
      { :post => "/rotations" }.
        should route_to(:controller => "rotations", :action => "create") 
    end

    it "recognizes and generates #edit" do
      { :get => "/rotations/1/edit" }.
        should route_to(:controller => "rotations", :action => "edit", :id => "1") 
    end

    it "recognizes and generates #update" do
      { :put => "/rotations/1" }.
        should route_to(:controller => "rotations", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/rotations/1" }.
        should route_to(:controller => "rotations", :action => "destroy", :id => "1") 
    end
  end
end
