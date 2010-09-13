require 'spec_helper'

describe MembershipsController do

  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/sections/1/memberships" }.
        should route_to(:controller => "memberships", :action => "index", :section_id => "1") 
    end

    it "recognizes and generates #new" do
      { :get => "/sections/1/memberships/new" }.
        should route_to(:controller => "memberships", :action => "new", :section_id => "1") 
    end
  end
end
