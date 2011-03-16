require 'spec_helper'

describe Shift do

  let(:mock_section) { stub_model(Section, :valid? => true) }
  let(:valid_attributes) do
    {
      :title => "value for title",
      :section_ids => [mock_section.id]
    }
  end
  let(:shift) do
    Shift.create!(valid_attributes)
  end

  before(:each) do
    Section.stub!(:find)
    Section.stub!(:find).with(mock_section.id, anything) { mock_section }
    Section.stub!(:find).with([mock_section.id]) { [mock_section] }
  end

  # database

  it { should have_db_column(:title).with_options(:null => false) }

  it do
    should have_db_column(:duration).
    of_type(:decimal).
    with_options(:precision => 2, :scale => 1, :default => 0.5, :null => false)
  end

  # associations

  it { should have_many(:shift_tag_assignments).through(:section_shifts) }

  it { should have_many(:shift_week_notes).dependent(:destroy) }

  it { should have_many(:section_shifts).dependent(:destroy) }

  it { should have_many(:sections).through(:section_shifts) }

  # validations

  it { should validate_presence_of(:title) }

  it { should validate_presence_of(:duration) }

  # methods
  
  # attribute cleanup

  [:title, :description, :phone].each do |attr|
    it { should clean_text_attribute(attr) }
  end
end
