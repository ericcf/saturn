require 'spec_helper'

describe ShiftTagsController do

  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/sections/1/shift_tags" }.
        should route_to(:controller => "shift_tags", :action => "index", :section_id => "1") 
    end

    it "recognizes and generates #new" do
      { :get => "/sections/1/shift_tags/new" }.
        should route_to(:controller => "shift_tags", :action => "new", :section_id => "1") 
    end

    it "recognizes and generates #create" do
      { :post => "/sections/1/shift_tags" }.
        should route_to(:controller => "shift_tags", :action => "create", :section_id => "1") 
    end

    it "recognizes and generates #search" do
      assert_recognizes({ :controller => "shift_tags", :action => "search", :section_id => "1", :format => "json" }, "/sections/1/shift_tags/search.json")
    end
  end
end
