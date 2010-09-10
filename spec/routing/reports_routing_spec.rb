require 'spec_helper'

describe ReportsController do

  describe "routing" do

    it "recognizes and generates #shift_totals" do
      { :get => "/sections/1/reports/shift_totals" }.
        should route_to(:controller => "reports", :action => "shift_totals", :section_id => "1") 
    end

    it "recognizes and generates #section_person_shift_totals" do
      { :get => "/sections/1/reports/people/2/shift_totals" }.
        should route_to(:controller => "reports", :action => "section_person_shift_totals", :section_id => "1", :person_id => "2")
    end
  end
end
