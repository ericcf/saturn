require "spec_helper"

describe UserNotifications do

  describe "new_assignment_request" do

    let(:mock_requester) { stub_model(Physician, :full_name => "Dr. Nick") }
    let(:mock_section) do
      stub_model(Section,
        :title => "ER",
        :administrator_emails => ["a@foo.com", "b@foo.com"]
      )
    end
    let(:mock_request) do
      stub_model(AssignmentRequest,
        :requester => mock_requester,
        :sections => [mock_section]
      )
    end
    let(:mail) { UserNotifications.new_assignment_request(mock_request) }

    subject { mail }

    it "renders the headers" do
      mail.subject.should eq("Saturn: Dr. Nick submitted a request")
      mail.to.should eq(mock_section.administrator_emails)
    end

    it "renders the requester's name in the body" do
      mail.body.encoded.should match(/Dr. Nick submitted an assignment request/)
    end

    it "renders a link to the section's meeting requests in the body" do
      mail.body.encoded.
        should match(/<a href="#{section_assignment_requests_url(mock_section)}">View all assignment requests for ER<\/a>/)
    end
  end
end
