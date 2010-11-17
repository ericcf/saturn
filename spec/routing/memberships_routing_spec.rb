require 'spec_helper'

describe MembershipsController do

  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/sections/1/memberships" }.
        should route_to(:controller => "memberships", :action => "index", :section_id => "1") 
    end

    it "recognizes and generates #manage_new" do
      { :get => "/sections/1/memberships/manage_new" }.
        should route_to(:controller => "memberships", :action => "manage_new", :section_id => "1") 
    end

    it "recognizes and generates #manage" do
      { :get => "/sections/1/memberships/manage" }.
        should route_to(:controller => "memberships", :action => "manage", :section_id => "1" )
    end
  end
end
