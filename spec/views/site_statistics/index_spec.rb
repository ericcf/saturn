require 'spec_helper'

describe "site_statistics/index" do

  before(:each) do
    @now = DateTime.now
    @mock_section = stub_model(Section, :title => "Section", :updated_at => @now)
    @mock_assignment = stub_model(Assignment, :updated_at => @now)
    @mock_assignment.stub_chain("weekly_schedule.section") { @mock_section }
    assign(:assignment_count, 5)
    assign(:recent_assignments, [@mock_assignment])
    assign(:section_count, 6)
    assign(:sections, [@mock_section])
    render
  end

  it do
    rendered.should have_selector("table tr") do |row|
      row.should have_selector("td", :content => "Assignments")
      row.should have_selector("td", :content => "5")
      row.should have_selector("td",
        :content => "Section: #{time_ago_in_words(@now)}")
    end
    rendered.should have_selector("table tr") do |row|
      row.should have_selector("td", :content => "Sections")
      row.should have_selector("td", :content => "6")
      row.should have_selector("td",
        :content => "Section: #{time_ago_in_words(@now)}")
    end
  end
end
