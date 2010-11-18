require 'spec_helper'

describe AdminsController do

  describe "routing" do

    it "recognizes and generates #show" do
      { :get => "/sections/1/admins" }.
        should route_to(:controller => "admins", :action => "show", :section_id => "1") 
    end

    it "recognizes and generates #update" do
      { :put => "/sections/1/admins" }.
        should route_to(:controller => "admins", :action => "update", :section_id => "1")
    end
  end
end
