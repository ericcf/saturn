require 'spec_helper'

describe "feedback_tickets/index" do

  before(:each) do
    @tickets = assign(:feedback_tickets, [
      mock_model(FeedbackTicket, :description => "Lorem ipsum...",
        :user => mock_model(User, :email => "abc@def.ghi"),
        :status => mock_model(FeedbackStatus, :name => "open"),
        :created_at => DateTime.now, :updated_at => DateTime.now)
    ])
    render
  end

  it "renders a table with ticket details" do
    ticket = @tickets.first
    rendered.should have_selector("table tr") do |row|
      row.should have_selector("td a", :href => feedback_ticket_path(ticket),
        :content => ticket.description)
      row.should have_selector("td", :content => ticket.user.email)
      row.should have_selector("td", :content => ticket.status.name)
      row.should have_selector("td", :content => ticket.created_at.to_s)
      row.should have_selector("td", :content => ticket.updated_at.to_s)
    end
  end
end
