require 'spec_helper'

describe HelpQuestionsController do

  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/help_questions" }.
        should route_to(:controller => "help_questions", :action => "index") 
    end

    it "recognizes and generates #new" do
      { :get => "/help_questions/new" }.
        should route_to(:controller => "help_questions", :action => "new") 
    end

    it "recognizes and generates #create" do
      { :post => "/help_questions" }.
        should route_to(:controller => "help_questions", :action => "create") 
    end

    it "recognizes and generates #edit" do
      { :get => "/help_questions/1/edit" }.
        should route_to(:controller => "help_questions", :action => "edit", :id => "1") 
    end

    it "recognizes and generates #update" do
      { :put => "/help_questions/1" }.
        should route_to(:controller => "help_questions", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/help_questions/1" }.
        should route_to(:controller => "help_questions", :action => "destroy", :id => "1") 
    end
  end
end
