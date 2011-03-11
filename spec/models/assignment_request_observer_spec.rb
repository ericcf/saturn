require 'spec_helper'

describe AssignmentRequestObserver do

  let(:mock_notification) { stub("notification") }
  let(:mock_request) { stub(AssignmentRequest) }
  let(:observer) { AssignmentRequestObserver.instance }

  it "sends a notification to the administrators when a request is created" do
    UserNotifications.stub!(:new_assignment_request).
      with(mock_request).
      and_return(mock_notification)
    mock_notification.should_receive(:deliver)
    observer.after_create(mock_request)
  end

  context "when a request is updated" do

    before(:each) do
      PhysicianNotifications.stub!(:assignment_request_approved).
        with(mock_request).
        and_return(mock_notification)
    end

    it "sends a physician notification if the request is approved" do
      mock_notification.should_receive(:deliver)
      mock_request.stub!(:status) { AssignmentRequest::STATUS[:approved] }
      observer.after_update(mock_request)
    end

    it "doesn't send a physician notification if the request is pending" do
      mock_notification.should_not_receive(:deliver)
      mock_request.stub!(:status) { AssignmentRequest::STATUS[:pending] }
      observer.after_update(mock_request)
    end
  end
end
