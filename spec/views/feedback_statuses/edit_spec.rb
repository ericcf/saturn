require 'spec_helper'

describe "feedback_statuses/edit" do

  before(:each) do
    assign(:feedback_status, stub_model(FeedbackStatus))
    should_render_partial("form")
    render
  end
end
