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
end
