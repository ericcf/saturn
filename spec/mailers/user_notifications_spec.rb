require "spec_helper"

describe UserNotifications do

  describe "new_vacation_request" do

    before(:each) do
      @requester = stub_model(Physician, :full_name => "Dr. Nick")
      @request = stub_model(VacationRequest, :requester => @requester)
      @recipients = ["a@foo.com", "b@foo.com"]
    end

    let(:mail) { UserNotifications.new_vacation_request(@request, @recipients) }

    it "renders the headers" do
      mail.subject.should eq("Saturn: New Vacation Request")
      mail.to.should eq(@recipients)
    end

    it "renders the body" do
      mail.body.encoded.should match(/#{@requester.full_name} submitted a vacation request/)
    end
  end

end
