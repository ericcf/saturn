require 'spec_helper'

describe "feedback_statuses/index" do

  before(:each) do
    @statuses = assign(:feedback_statuses, [
      mock_model(FeedbackStatus, :name => "Foo", :default => false),
      mock_model(FeedbackStatus, :name => "Bar", :default => true)
    ]
    )
    render
  end

  it "renders a link to add a new status" do
    rendered.should have_selector("a", :href => new_feedback_status_path,
      :content => "Add Status")
  end

  it "renders a list of statuses, indicating the default" do
    rendered.should have_selector("ul li a",
      :href => edit_feedback_status_path(@statuses.first),
      :content => @statuses.first.name)
    rendered.should have_selector("ul li") do |item|
      item.should have_selector("a",
        :href => edit_feedback_status_path(@statuses.second),
        :content => @statuses.second.name)
      item.should contain("*")
    end
  end
end
