require "spec_helper"

describe UserNotifications do

  describe "new_vacation_request" do

    before(:each) do
      @requester = stub_model(Physician, :full_name => "Dr. Nick")
      @section = stub_model(Section, :title => "ER")
      @request = stub_model(VacationRequest, :requester => @requester,
        :section => @section)
      @recipients = ["a@foo.com", "b@foo.com"]
    end

    let(:mail) { UserNotifications.new_vacation_request(@request, @recipients) }

    it "renders the headers" do
      mail.subject.should eq("Saturn: New Vacation Request")
      mail.to.should eq(@recipients)
    end

    it "renders the requester's name in the body" do
      mail.body.encoded.
        should match(/#{@requester.full_name} submitted a vacation request/)
    end

    it "renders a link to the section's vacation requests in the body" do
      mail.body.encoded.
        should match(/<a href="#{section_vacation_requests_url(@section)}">View all vacation requests for ER<\/a>/)
    end
  end

  describe "new_meeting_request" do

    before(:each) do
      @requester = stub_model(Physician, :full_name => "Dr. Nick")
      @section = stub_model(Section, :title => "ER")
      @request = stub_model(MeetingRequest, :requester => @requester,
        :section => @section)
      @recipients = ["a@foo.com", "b@foo.com"]
    end

    let(:mail) { UserNotifications.new_meeting_request(@request, @recipients) }

    it "renders the headers" do
      mail.subject.should eq("Saturn: New Meeting Request")
      mail.to.should eq(@recipients)
    end

    it "renders the requester's name in the body" do
      mail.body.encoded.
        should match(/#{@requester.full_name} submitted a meeting request/)
    end

    it "renders a link to the section's meeting requests in the body" do
      mail.body.encoded.
        should match(/<a href="#{section_meeting_requests_url(@section)}">View all meeting requests for ER<\/a>/)
    end
  end
end
