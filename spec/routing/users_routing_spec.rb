require 'spec_helper'

describe UsersController do

  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/users" }.
        should route_to(:controller => "users", :action => "index") 
    end

    it "recognizes and generates #update_roles" do
      { :put => "/users/roles" }.
        should route_to(:controller => "users", :action => "update_roles") 
    end
  end
end
