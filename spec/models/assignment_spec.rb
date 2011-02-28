require 'spec_helper'

describe Assignment do

  let(:mock_shift) { stub_model(Shift) }
  let(:mock_physician) { stub_model(Physician) }
  let(:valid_attributes) do
    {
      :shift_id => mock_shift.id,
      :physician_id => mock_physician.id,
      :date => Date.today,
      :position => 1,
      :public_note => "value for public_note",
      :private_note => "value for private_note",
      :duration => 9.99
    }
  end
  let(:assignment) { Assignment.create!(valid_attributes) }

  before(:each) do
    Shift.stub!(:find).with(mock_shift.id, anything) { mock_shift }
    Physician.stub!(:find).with(mock_physician.id, anything) { mock_physician }
  end

  subject { assignment }

  # database

  it { should have_db_column(:shift_id).with_options(:null => false) }

  it { should have_db_column(:physician_id).with_options(:null => false) }

  it { should have_db_column(:date).with_options(:null => false) }

  it { should have_db_column(:position).
    of_type(:integer).
    with_options(:null => false, :default => 1) }

  it { should have_db_column(:duration).
    of_type(:decimal).
    with_options(:precision => 2, :scale => 1) }

  it { should have_db_index([:date, :shift_id]) }

  it { should have_db_index(:date) }

  it { should have_db_index(:physician_id) }

  # associations

  it { should belong_to(:shift) }

  it { should belong_to(:physician) }

  # validations

  it { should validate_presence_of(:shift_id) }

  it { should validate_presence_of(:physician_id) }

  it { should validate_presence_of(:date) }

  it { should validate_numericality_of(:position) }

  it { should validate_uniqueness_of(:physician_id).
    scoped_to(:shift_id, :date).
    with_message(/Duplicate assignments not allowed/) }

  [-1, 0].each do |value|
    it "does not allow #{value} for position" do
      assignment.update_attributes(:position => value)
      assignment.should have(1).error_on(:position)
    end
  end

  [1, 100].each do |value|
    it "allows #{value} for position" do
      assignment.update_attributes(:position => value)
      assignment.should have(:no).errors_on(:position)
    end
  end

  # attribute filtering

  it "converts non-numeric durations to nil" do
    assignment.update_attributes(:duration => "a string")
    assignment.duration.should be_nil
  end

  it "stores string representations of decimals as decimals" do
    assignment.update_attributes(:duration => "1.0")
    assignment.duration.should == 1.0
  end

  # scopes

  describe ".date_in_range(start_date, end_date)" do

    it "returns assignments with dates included in the range" do
      Assignment.date_in_range(assignment.date, assignment.date).
        should include(assignment)
    end

    it "does not return assignments with dates outside the range" do
      Assignment.date_in_range(assignment.date + 1, assignment.date + 2).
        should_not include(assignment)
    end
  end

  # methods
  
  describe "#physician_name" do

    it "returns the associated physician's short_name" do
      mock_physician.stub!(:short_name) { "short name" }
      assignment.physician_name.should == "short name"
    end
  end

  describe "#shift_title" do

    it "returns the associated shift's title" do
      mock_shift.stub!(:title) { "shift title" }
      assignment.shift_title.should == "shift title"
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

  describe "#to_json" do

    it "serializes the object as valid json" do
      expect { JSON.parse(assignment.to_json) }.
        to_not raise_error(JSON::ParserError)
    end
  end
end
