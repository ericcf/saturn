require 'spec_helper'

describe "feedback_tickets/new" do

  before(:each) do
    assign(:feedback_ticket, stub_model(FeedbackTicket))
    should_render_partial("form")
    render
  end
end
