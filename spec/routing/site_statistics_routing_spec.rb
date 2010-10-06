require 'spec_helper'

describe SiteStatisticsController do

  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/admin/site_statistics" }.
        should route_to(:controller => "site_statistics", :action => "index") 
    end
  end
end
