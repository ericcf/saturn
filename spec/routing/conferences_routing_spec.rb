require "spec_helper"

describe ConferencesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/conferences" }.should route_to(:controller => "conferences", :action => "index")
    end

    it "recognizes and generates #show" do
      { :get => "/conferences/1" }.should route_to(:controller => "conferences", :action => "show", :id => "1")
    end
  end
end
