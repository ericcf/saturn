require 'spec_helper'

describe Assignment do

  before(:each) do
    mock_schedule = mock_model(WeeklySchedule)
    WeeklySchedule.stub!(:find).with(mock_schedule.id, anything).
      and_return(mock_schedule)
    mock_shift = stub_model(Shift)
    Shift.stub!(:find).with(mock_shift.id, anything).and_return(mock_shift)
    physician = stub_model(Physician)
    Physician.stub!(:find).with(physician.id, anything).and_return(physician)
    @valid_attributes = {
      :weekly_schedule_id => mock_schedule.id,
      :shift_id => mock_shift.id,
      :physician_id => physician.id,
      :date => Date.today,
      :position => 1,
      :public_note => "value for public_note",
      :private_note => "value for private_note",
      :duration => 9.99
    }
    Assignment.create!(@valid_attributes).should be_valid
  end

  # database

  it { should have_db_column(:weekly_schedule_id).
    with_options(:null => false) }

  it { should have_db_column(:shift_id).with_options(:null => false) }

  it { should have_db_column(:physician_id).with_options(:null => false) }

  it { should have_db_column(:date).with_options(:null => false) }

  it { should have_db_column(:position).
    of_type(:integer).
    with_options(:null => false, :default => 1) }

  it { should have_db_column(:duration).
    of_type(:decimal).
    with_options(:precision => 2, :scale => 1) }

  it { should have_db_index([:weekly_schedule_id, :shift_id]) }

  it { should have_db_index(:weekly_schedule_id) }

  it { should have_db_index(:physician_id) }

  # associations

  it { should belong_to(:weekly_schedule) }

  it { should belong_to(:shift) }

  it { should belong_to(:physician) }

  # validations

  it { should validate_presence_of(:shift_id) }

  it { should validate_presence_of(:physician_id) }

  it { should validate_presence_of(:date) }

  it { should validate_numericality_of(:position) }

  it { should validate_uniqueness_of(:physician_id).
    scoped_to(:weekly_schedule_id, :shift_id, :date).
    with_message(/Duplicate assignments not allowed/) }

  [-1, 0].each do |value|
    it "does not allow #{value} for position" do
      Assignment.new(@valid_attributes.merge({:position => value})).
        should have(1).error_on(:position)
    end
  end

  [1, 100].each do |value|
    it "allows #{value} for position" do
      Assignment.new(@valid_attributes.merge({:position => value})).
        should have(:no).errors_on(:position)
    end
  end

  # attribute filtering

  it "converts non-numeric durations to nil" do
    a = Assignment.new(@valid_attributes.merge({ :duration => "a string" }))
    a.valid?
    a.duration.should be_nil
  end

  it "stores string representations of decimals as decimals" do
    a = Assignment.new(@valid_attributes.merge({ :duration => "1.0" }))
    a.valid?
    a.duration.should == 1.0
  end

  # methods
  
  describe "#public_note_details" do

    context "no public note" do

      it "returns nil" do
        Assignment.new(@valid_attributes.merge({ :public_note => "" })).
          public_note_details.should be_nil
      end
    end

    context "public note present" do

      it "returns a details hash" do
        physician = mock_model(Physician, :initials => "AB")
        Physician.stub!(:find).and_return(physician)
        attributes = @valid_attributes.merge({
          :public_note => "Foo!",
          :physician_id => physician.id
        })
        detail_keys = Assignment.new(attributes).public_note_details.keys
        detail_keys.should include(:shift)
        detail_keys.should include(:day)
        detail_keys.should include(:initials)
        detail_keys.should include(:text)
      end
    end
  end

  describe "#fixed_duration" do

    context "duration is not set" do

      it "returns the shift duration" do
        Assignment.new(:shift => mock_model(Shift, :duration => 1.0)).
          fixed_duration.should == 1.0
      end
    end

    context "duration is set" do

      it "returns the assignment duration" do
        Assignment.new(
          :duration => 2.0,
          :shift => mock_model(Shift, :duration => 1.0)
        ).fixed_duration.should == 2.0
      end
    end
  end

  describe "#to_ics_event(:event)" do

    it "initializes a vpim calendar event" do
      date = Date.today
      shift = Shift.create(:title => "Foo")
      assignment = Assignment.new(:date => date, :shift => shift)
      vpim_event = stub("event")
      vpim_event.should_receive(:dtstart).with(date)
      vpim_event.should_receive(:dtend).with(date)
      vpim_event.should_receive(:summary).with(shift.title)
      assignment.to_ics_event(vpim_event)
    end
  end
end
