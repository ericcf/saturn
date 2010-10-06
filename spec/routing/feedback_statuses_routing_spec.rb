require 'spec_helper'

describe FeedbackStatusesController do

  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/feedback_statuses" }.
        should route_to(:controller => "feedback_statuses", :action => "index") 
    end

    it "recognizes and generates #show" do
      { :get => "/feedback_statuses/1" }.
        should route_to(:controller => "feedback_statuses", :action => "show", :id => "1") 
    end

    it "recognizes and generates #new" do
      { :get => "/feedback_statuses/new" }.
        should route_to(:controller => "feedback_statuses", :action => "new") 
    end

    it "recognizes and generates #create" do
      { :post => "/feedback_statuses" }.
        should route_to(:controller => "feedback_statuses", :action => "create") 
    end

    it "recognizes and generates #edit" do
      { :get => "/feedback_statuses/1/edit" }.
        should route_to(:controller => "feedback_statuses", :action => "edit", :id => "1") 
    end

    it "recognizes and generates #update" do
      { :put => "/feedback_statuses/1" }.
        should route_to(:controller => "feedback_statuses", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/feedback_statuses/1" }.
        should route_to(:controller => "feedback_statuses", :action => "destroy", :id => "1") 
    end
  end
end
