require 'spec_helper'

describe "site_statistics/index" do

  before(:each) do
    @now = DateTime.now
    assign(:assignment_count, 5)
    assign(:assignments_last_updated, @now)
    assign(:section_count, 6)
    assign(:sections_last_updated, @now)
    render
  end

  it do
    rendered.should have_selector("table tr") do |row|
      row.should have_selector("td", :content => "Assignments")
      row.should have_selector("td", :content => "5")
      row.should have_selector("td", :content => time_ago_in_words(@now))
    end
    rendered.should have_selector("table tr") do |row|
      row.should have_selector("td", :content => "Sections")
      row.should have_selector("td", :content => "6")
      row.should have_selector("td", :content => time_ago_in_words(@now))
    end
  end
end
