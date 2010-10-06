require 'spec_helper'

describe "feedback_tickets/_form" do

  before(:each) do
    assign(:feedback_ticket, stub_model(FeedbackTicket))
    render
  end

  it "renders a field for the description" do
    rendered.should have_selector("form textarea",
      :name => "feedback_ticket[description]")
  end
end
