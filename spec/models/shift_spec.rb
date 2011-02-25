require 'spec_helper'

describe Shift do

  let(:mock_section) { stub_model(Section) }
  let(:valid_attributes) do
    {
      :title => "value for title"
    }
  end
  let(:shift) { Shift.create!(valid_attributes) }

  before(:each) do
    Section.stub!(:find)
    Section.stub!(:find).with(mock_section.id, anything) { mock_section }
  end

  # database

  it { should have_db_column(:title).with_options(:null => false) }

  it do
    should have_db_column(:duration).
    of_type(:decimal).
    with_options(:precision => 2, :scale => 1, :default => 0.5, :null => false)
  end

  # associations

  it { should have_many(:shift_tag_assignments).dependent(:destroy) }

  it { should have_many(:shift_tags).through(:shift_tag_assignments) }

  it { should have_many(:shift_week_notes).dependent(:destroy) }

  it { should have_many(:section_shifts).dependent(:destroy) }

  it { should have_many(:sections).through(:section_shifts) }

  # validations

  it { should validate_presence_of(:title) }

  it { should validate_presence_of(:duration) }

  # methods
  
  describe "#tags" do

    it "returns a comma separated list of tag titles" do
      shift.stub!(:shift_tags).and_return([
        stub_model(ShiftTag, :title => "Foo"),
        stub_model(ShiftTag, :title => "Bar")
      ])
      shift.tags.should eq("Foo, Bar")
    end
  end
  
  describe "#tags=(:tags_string)" do

    before(:each) do
      @mock_shift_tag = mock_model(ShiftTag)
      @mock_shift_tags = []
      shift.stub!(:shift_tags).and_return(@mock_shift_tags)
      mock_section_shift_tags = mock("section shift tags", :find_or_create_by_title => @mock_shift_tag)
      mock_section = mock_model(Section, :shift_tags => mock_section_shift_tags)
      shift.stub!(:section).and_return(mock_section)
    end

    it "ignores extraneous commas in the list" do
      @mock_shift_tags.should_receive(:<<).with(@mock_shift_tag).once
      shift.tags = "Foo, "
    end

    context "tags in the list are not already associated" do

      it "adds the associated shift tags" do
        @mock_shift_tags.should_receive(:<<).with(@mock_shift_tag).
          exactly(2).times
        shift.tags = "Foo, Bar"
      end
    end

    context "tags in the list are already associated" do

      it "does nothing" do
        @mock_shift_tags = [mock_model(ShiftTag, :title => "Foo")]
        @mock_shift_tags.should_not_receive(:<<)
        shift.tags = "Foo"
      end
    end
  end

  # attribute cleanup

  [:title, :description, :phone].each do |attr|
    it { should clean_text_attribute(attr) }
  end
end
