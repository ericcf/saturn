require 'spec_helper'

describe AssignmentRequest do

  let(:mock_section) { mock_model(Section, :administrator_emails => []).as_null_object }
  let(:mock_requester) do
    stub_model(Physician,
               :shifts => [mock_shift],
               :full_name => "Aaa Baa",
               :emails => [])
  end
  let(:mock_shift) do
    mock_model(Shift,
      :sections => [mock_section],
      :title => "Clinic",
      :valid? => true
    )
  end
  let(:today) { Date.today }
  let(:valid_attributes) do
    Physician.stub!(:find).with(mock_requester.id) { mock_requester }
    {
      :requester_id => mock_requester.id,
      :shift => mock_shift,
      :status => AssignmentRequest::STATUS[:pending],
      :start_date => today
    }
  end
  let(:request) { AssignmentRequest.create!(valid_attributes) }

  subject { request }

  # database

  it { should have_db_column(:requester_id).with_options(:null => false) }

  it { should have_db_column(:shift_id).with_options(:null => false) }

  it do
    should have_db_column(:status).
      with_options(:null => false, :default => "pending")
  end

  it { should have_db_column(:start_date).with_options(:null => false) }

  it { should have_db_index(:requester_id) }

  it { should have_db_index(:shift_id) }

  # associations

  it { should belong_to(:shift) }

  # validations

  it { should validate_presence_of(:requester_id) }

  it { should validate_presence_of(:shift) }

  it { should validate_presence_of(:status) }

  it { should validate_presence_of(:start_date) }

  it { should validate_associated(:shift) }

  describe "validates logical start and end dates" do

    it "allows end_date to be equal to start_date" do
      request.end_date = request.start_date
      request.should be_valid
    end

    it "allows end_date to be after start_date" do
      request.end_date = request.start_date + 1
      request.should be_valid
    end

    it "does not allow end_date to be before start_date" do
      request.end_date = request.start_date - 1
      request.should_not be_valid
    end

    it "does not allow start_date to be before today" do
      request.start_date = today - 1
      request.should_not be_valid
    end
  end

  describe "validates inclusion of status in AssignmentRequest::STATUS" do

    AssignmentRequest::STATUS.values.each do |status|
      it { should allow_value(status).for(:status) }
    end

    it { should_not allow_value("moops").for(:status) }
  end

  # methods

  describe "#approve!" do

    before(:each) { Assignment.stub!(:create_for_dates) }

    it "sets status to approved" do
      request.approve!
      request.status.should == AssignmentRequest::STATUS[:approved]
    end

    context "end_date is nil" do

      it "creates an assignment for the specified physician, shift and date" do
        Assignment.should_receive(:create_for_dates).
          with([request.start_date],
            :shift_id => request.shift.id,
            :physician_id => request.requester.id
          )
        request.approve!
      end
    end

    context "end_date is not nil" do

      it "creates an assignment for each date in the range" do
        request.end_date = today + 5
        dates = (request.start_date..request.end_date).to_a
        Assignment.should_receive(:create_for_dates).
          with(dates,
            :shift_id => request.shift.id,
            :physician_id => request.requester.id
          )
        request.approve!
      end
    end
  end
end
