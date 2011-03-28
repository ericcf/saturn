require "spec_helper"

describe PhysicianNotifications do

  describe "assignment_request_approved" do

    let(:mock_requester) do
      mock_model(Physician, :full_name => "Dr. Nick", :work_email => "u@n.com")
    end
    let(:today) { Date.today }
    let(:tomorrow) { Date.tomorrow }
    let(:mock_request) do
      mock_model(AssignmentRequest,
        :requester => mock_requester,
        :shift_title => "Meeting",
        :start_date => today,
        :end_date => tomorrow
      )
    end
    let(:mail) do
      PhysicianNotifications.assignment_request_approved(mock_request)
    end

    it "renders the headers" do
      mail.subject.should eq("Request approved")
      mail.to.should eq([mock_requester.work_email])
      mail.from.should eq([APP_CONFIG["from_email"]])
    end

    context "in the body of the email" do

      subject { mail.body.encoded }

      it "renders the shift title" do
        should match(/#{mock_request.shift_title}/)
      end

      it "renders the start and end dates" do
        should match(/#{mock_request.start_date.to_s(:short_with_weekday)}/)
        should match(/#{mock_request.end_date.to_s(:short_with_weekday)}/)
      end
      
      it "renders a link to the requester's schedule" do
        should match(/<a href="#{schedule_physician_url(mock_requester)}">View your schedule here<\/a>/)
      end
    end
  end
end
