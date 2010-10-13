require 'spec_helper'

describe PhysicianAliasesController do

  describe "routing" do

    it "recognizes and generates #new" do
      { :get => "/physicians/1/physician_alias/new" }.
        should route_to(:controller => "physician_aliases", :action => "new", :physician_id => "1") 
    end

    it "recognizes and generates #create" do
      { :post => "/physicians/1/physician_alias" }.
        should route_to(:controller => "physician_aliases", :action => "create", :physician_id => "1") 
    end

    it "recognizes and generates #edit" do
      { :get => "/physicians/1/physician_alias/edit" }.
        should route_to(:controller => "physician_aliases", :action => "edit", :physician_id => "1") 
    end

    it "recognizes and generates #update" do
      { :put => "/physicians/1/physician_alias" }.
        should route_to(:controller => "physician_aliases", :action => "update", :physician_id => "1") 
    end
  end
end
