require 'spec_helper'

describe RulesController do

  describe "routing" do

    it "recognizes and generates #show" do
      { :get => "/sections/1/rules" }.
        should route_to(:controller => "rules", :action => "show", :section_id => "1") 
    end

    it "recognizes and generates #edit" do
      { :get => "/sections/1/rules/edit" }.
        should route_to(:controller => "rules", :action => "edit", :section_id => "1") 
    end

    it "recognizes and generates #update" do
      { :put => "/sections/1/rules" }.
        should route_to(:controller => "rules", :action => "update", :section_id => "1") 
    end
  end
end
