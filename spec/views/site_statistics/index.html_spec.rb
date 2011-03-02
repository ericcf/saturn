require 'spec_helper'

describe "site_statistics/index.html" do

  let(:now) { DateTime.now }

  before(:each) do
    mock_section = stub_model(Section, :title => "Section", :updated_at => now)
    mock_assignment = stub_model(Assignment, :updated_at => now)
    mock_assignment.stub_chain("weekly_schedule.section") { mock_section }
    assign(:assignment_count, 5)
    assign(:recent_assignments, [mock_assignment])
    assign(:section_count, 6)
    assign(:sections, [mock_section])
    render
  end

  subject { rendered }

  it do
    should have_selector("table tr") do |row|
      row.should have_selector("td", :content => "Assignments")
      row.should have_selector("td", :content => "5")
    end
  end
end
