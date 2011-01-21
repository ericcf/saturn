require 'spec_helper'

describe ReportsController do

  describe "routing" do

    it "recognizes and generates #shift_totals" do
      { :get => "/sections/1/reports/shift_totals" }.
        should route_to(:controller => "reports", :action => "shift_totals", :section_id => "1") 
    end

    it "recognizes and generates #search_shift_totals" do
      { :get => "/sections/1/reports/search_shift_totals" }.
        should route_to(:controller => "reports", :action => "search_shift_totals", :section_id => "1") 
    end

    it "recognizes and generates #shift_totals_report" do
      { :get => "/sections/1/reports/shift_totals_report" }.
        should route_to(:controller => "reports", :action => "shift_totals_report", :section_id => "1") 
    end

    it "recognizes and generates #shift_totals_by_day" do
      { :get => "/sections/1/reports/shifts/2/totals_by_day" }.
        should route_to(:controller => "reports", :action => "shift_totals_by_day", :section_id => "1", :shift_id => "2") 
    end

    it "recognizes and generates #section_physician_shift_totals" do
      { :get => "/sections/1/reports/people/2/shift_totals" }.
        should route_to(:controller => "reports", :action => "section_physician_shift_totals", :section_id => "1", :physician_id => "2")
    end
  end
end
