require 'spec_helper'

describe "feedback_statuses/new" do

  before(:each) do
    assign(:feedback_status, stub_model(FeedbackStatus))
    should_render_partial("form")
    render
  end
end
