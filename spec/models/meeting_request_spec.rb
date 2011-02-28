require 'spec_helper'

describe MeetingRequest do

  let(:mock_physician) { stub_model(Physician, :valid? => true) }
  let(:mock_section) { stub_model(Section, :valid? => true) }
  let(:mock_shift) { stub_model(Shift, :valid? => true) }
  let(:valid_attributes) do
    Physician.stub!(:find).with(mock_physician.id, anything) { mock_physician }
    Section.stub!(:find).with(mock_section.id, anything) { mock_section }
    Shift.stub!(:find).with(mock_shift.id, anything) { mock_shift }
    {
      :requester => mock_physician,
      :section => mock_section,
      :shift => mock_shift,
      :status => MeetingRequest::STATUS_PENDING,
      :start_date => Date.today
    }
  end
  let(:meeting_request) { MeetingRequest.create!(valid_attributes) }

  # database

  it { should have_db_column(:requester_id).with_options(:null => false) }

  it { should have_db_column(:section_id).with_options(:null => false) }

  it { should have_db_column(:shift_id).with_options(:null => false) }

  it { should have_db_column(:status).with_options(:null => false, :default => "pending") }

  it { should have_db_column(:start_date).with_options(:null => false) }

  it { should have_db_index(:requester_id) }

  it { should have_db_index(:section_id) }

  it { should have_db_index(:status) }

  # associations

  it { should belong_to(:requester) }

  it { should belong_to(:section) }

  it { should belong_to(:shift) }

  # validations

  it { should validate_presence_of(:requester) }

  it { should validate_presence_of(:section) }

  it { should validate_presence_of(:shift) }

  it { should validate_presence_of(:status) }

  it { should validate_presence_of(:start_date) }

  it { should validate_associated(:requester) }

  it { should validate_associated(:section) }

  it { should validate_associated(:shift) }

  it "allows end_date to be equal to start_date" do
    meeting_request.end_date = meeting_request.start_date
    meeting_request.should be_valid
  end

  it "allows end_date to be after start_date" do
    meeting_request.end_date = meeting_request.start_date + 1
    meeting_request.should be_valid
  end

  it "does not allow end_date to be before start_date" do
    meeting_request.end_date = meeting_request.start_date - 1
    meeting_request.should_not be_valid
  end

  MeetingRequest::STATUSES.each do |status|
    it { should allow_value(status).for(:status) }
  end

  it { should_not allow_value("moops").for(:status) }

  # methods

  describe ".approve" do

    let(:start_date) { Date.parse("2010-12-30") }
    let(:end_date) { Date.parse("2010-12-31") }
    let(:mock_assignments_assoc) { stub("assignments") }

    it "creates a new meeting assignment for each date in the range" do
      meeting_request.
        update_attributes(:start_date => start_date, :end_date => end_date)
      mock_schedule = stub_model(WeeklySchedule)
      mock_schedule.stub!(:assignments) { mock_assignments_assoc }
      [start_date, end_date].each do |date|
        mock_section.stub!(:find_or_create_weekly_schedule_by_included_date).
          with(date).
          and_return(mock_schedule)
        Assignment.should_receive(:create).
          with(:date => date,
            :shift => mock_shift,
            :physician_id => mock_physician.id
          )
      end
      meeting_request.approve
    end

    it "sets the status to 'approved'" do
      meeting_request.approve
      mock_section.stub!(:find_or_create_weekly_schedule_by_included_date).
        and_return(stub_model(WeeklySchedule))
      meeting_request.status.should eq(MeetingRequest::STATUS_APPROVED)
    end
  end
end
