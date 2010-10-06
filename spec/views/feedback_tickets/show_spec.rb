require 'spec_helper'

describe "feedback_tickets/show" do

  before(:each) do
    @ticket = assign(:feedback_ticket, mock_model(FeedbackTicket,
      :description => "Lorem ipsum...",
      :user => mock_model(User, :email => "abc@def.hij"),
      :request_url => "http://foo.com?bar=baz",
      :status => mock_model(FeedbackStatus, :name => "open"),
      :comments => "I can't believe it's not butter!",
      :created_at => DateTime.now,
      :updated_at => DateTime.now)
    )
    view.should_receive(:nav_item).with("Edit",
      edit_feedback_ticket_path(@ticket), {}, :update, @ticket)
    render
  end

  it "renders the ticket details" do
    rendered.should have_selector("dl") do |list|
      list.should have_selector("dd", :content => @ticket.description)
      list.should have_selector("dd", :content => @ticket.user.email)
      list.should have_selector("dd", :content => @ticket.request_url)
      list.should have_selector("dd", :content => @ticket.status.name)
      list.should have_selector("dd", :content => @ticket.comments)
      list.should have_selector("dd", :content => @ticket.created_at.to_s)
      list.should have_selector("dd", :content => @ticket.updated_at.to_s)
    end
  end
end
