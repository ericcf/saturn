require 'spec_helper'

describe SectionMembershipObserver do

  let(:mock_physician) { mock_model(Physician, :work_email => "foo@bar.com") }
  let(:mock_membership) do
    mock_model(SectionMembership, :physician => mock_physician)
  end
  let(:observer) { SectionMembershipObserver.instance }

  it "creates an associated User when a membership is created" do
    User.should_receive(:create).with(hash_including(
      :email => mock_physician.work_email,
      :physician_id => mock_physician.id
    ))
    observer.after_create(mock_membership)
  end
end
