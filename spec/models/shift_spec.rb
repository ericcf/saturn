require 'spec_helper'

describe Shift do

  before(:each) do
    mock_section = stub_model(Section)
    Section.stub!(:find)
    Section.stub!(:find).with(mock_section.id, anything) { mock_section }
    @valid_attributes = {
      :section_id => mock_section.id,
      :title => "value for title",
      :description => "value for description",
      :duration => "value for duration",
      :position => 1
    }
    @shift = Shift.create(@valid_attributes)
    @shift.should be_valid
  end

  # database

  it { should have_db_column(:title).with_options(:null => false) }

  it do
    should have_db_column(:duration).
    of_type(:decimal).
    with_options(:precision => 2, :scale => 1, :default => 0.5, :null => false)
  end

  it { should have_db_column(:position).
    with_options(:default => 1, :null => false) }

  it { should have_db_column(:section_id).
    with_options(:null => false) }

  it { should have_db_index(:section_id) }

  # associations

  it { should have_many(:shift_tag_assignments).dependent(:destroy) }

  it { should have_many(:shift_tags).through(:shift_tag_assignments) }

  it { should have_many(:shift_week_notes).dependent(:destroy) }

  it { should belong_to(:section) }

  # validations

  it { should validate_presence_of(:title) }

  it { should validate_uniqueness_of(:title).scoped_to(:section_id) }

  it { should validate_presence_of(:duration) }

  it { should validate_presence_of(:position) }

  it { should validate_presence_of(:section) }

  it { should allow_value("#0369bf").for(:display_color) }

  it { should allow_value("#000").for(:display_color) }

  it { should allow_value(nil).for(:display_color) }

  it { should_not allow_value("ffffff").for(:display_color) }

  it { should_not allow_value("#qwerty").for(:display_color) }

  # scopes

  describe ".active_as_of(:cutoff_date)" do

    it "returns shifts with nil retired_on" do
      @shift.update_attributes({ :retired_on => nil })
      Shift.active_as_of(Date.today).should include(@shift)
    end

    it "returns shifts with retired_on > cutoff_date" do
      @shift.update_attributes({ :retired_on => Date.tomorrow })
      Shift.active_as_of(Date.yesterday).should include(@shift)
    end

    it "does not return shifts with retired_on < cutoff_date" do
      @shift.update_attributes({ :retired_on => Date.yesterday })
      Shift.active_as_of(Date.tomorrow).should_not include(@shift)
    end
  end

  describe ".retired_as_of(:cutoff_date)" do

    it "does not return shifts with retired_on == nil" do
      @shift.update_attributes({ :retired_on => nil })
      Shift.retired_as_of(Date.today).should_not include(@shift)
    end

    it "returns shifts with retired_on < cutoff_date" do
      @shift.update_attributes({ :retired_on => Date.yesterday })
      Shift.retired_as_of(Date.tomorrow).should include(@shift)
    end

    it "does not return shifts with retired_on > cutoff_date" do
      @shift.update_attributes({ :retired_on => Date.tomorrow })
      Shift.retired_as_of(Date.yesterday).should_not include(@shift)
    end
  end

  # methods
  
  describe "#tags" do

    it "returns a comma separated list of tag titles" do
      @shift.stub!(:shift_tags).and_return([
        stub_model(ShiftTag, :title => "Foo"),
        stub_model(ShiftTag, :title => "Bar")
      ])
      @shift.tags.should eq("Foo, Bar")
    end
  end
  
  describe "#tags=(:tags_string)" do

    before(:each) do
      @mock_shift_tag = mock_model(ShiftTag)
      @mock_shift_tags = []
      @shift.stub!(:shift_tags).and_return(@mock_shift_tags)
      mock_section_shift_tags = mock("section shift tags", :find_or_create_by_title => @mock_shift_tag)
      mock_section = mock_model(Section, :shift_tags => mock_section_shift_tags)
      @shift.stub!(:section).and_return(mock_section)
    end

    it "ignores extraneous commas in the list" do
      @mock_shift_tags.should_receive(:<<).with(@mock_shift_tag).once
      @shift.tags = "Foo, "
    end

    context "tags in the list are not already associated" do

      it "adds the associated shift tags" do
        @mock_shift_tags.should_receive(:<<).with(@mock_shift_tag).
          exactly(2).times
        @shift.tags = "Foo, Bar"
      end
    end

    context "tags in the list are already associated" do

      it "does nothing" do
        @mock_shift_tags = [mock_model(ShiftTag, :title => "Foo")]
        @mock_shift_tags.should_not_receive(:<<)
        @shift.tags = "Foo"
      end
    end
  end

  describe "#retire=(:value)" do

    context "value is like true" do

      it "retired_on is set to today" do
        @shift.retire = "1"
        @shift.retired_on.should == Date.today
      end
    end
  end

  # attribute cleanup

  [:title, :description, :phone].each do |attr|
    it { should clean_text_attribute(attr) }
  end
end
