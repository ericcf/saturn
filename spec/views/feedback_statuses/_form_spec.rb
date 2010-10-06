require 'spec_helper'

describe "feedback_statuses/_form" do

  before(:each) do
    assign(:feedback_status, stub_model(FeedbackStatus))
    render
  end

  it "renders a field for name" do
    rendered.should have_selector("form input",
      :name => "feedback_status[name]")
  end

  it "renders a field for default status" do
    rendered.should have_selector("form input",
      :name => "feedback_status[default]")
  end
end
