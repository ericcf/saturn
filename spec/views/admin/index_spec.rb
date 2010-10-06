require 'spec_helper'

describe "admin/index" do

  before(:each) do
    render
  end

  it "renders a link to site statistics" do
    rendered.should have_selector("ul li a", :href => site_statistics_path,
      :content => "Site Statistics")
  end

  it "renders a link to feedback tickets" do
    rendered.should have_selector("ul li a", :href => feedback_tickets_path,
      :content => "Feedback Tickets")
  end

  it "renders a link to feedback statuses" do
    rendered.should have_selector("ul li a", :href => feedback_statuses_path,
      :content => "Feedback Statuses")
  end
end
