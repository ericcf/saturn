require 'spec_helper'

describe FeedbackTicketsController do

  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/feedback_tickets" }.
        should route_to(:controller => "feedback_tickets", :action => "index") 
    end

    it "recognizes and generates #show" do
      { :get => "/feedback_tickets/1" }.
        should route_to(:controller => "feedback_tickets", :action => "show", :id => "1") 
    end

    it "recognizes and generates #new" do
      { :get => "/feedback_tickets/new" }.
        should route_to(:controller => "feedback_tickets", :action => "new") 
    end

    it "recognizes and generates #create" do
      { :post => "/feedback_tickets" }.
        should route_to(:controller => "feedback_tickets", :action => "create") 
    end

    it "recognizes and generates #edit" do
      { :get => "/feedback_tickets/1/edit" }.
        should route_to(:controller => "feedback_tickets", :action => "edit", :id => "1") 
    end

    it "recognizes and generates #update" do
      { :put => "/feedback_tickets/1" }.
        should route_to(:controller => "feedback_tickets", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/feedback_tickets/1" }.
        should route_to(:controller => "feedback_tickets", :action => "destroy", :id => "1") 
    end
  end
end
