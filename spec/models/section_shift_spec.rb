require 'spec_helper'

describe SectionShift do

  let(:mock_section) { stub_model(Section, :valid? => true) }
  let(:mock_shift) { stub_model(Shift, :valid? => true) }
  let(:valid_attributes) do
    Section.stub!(:find).with(mock_section.id, anything) { mock_section }
    Shift.stub!(:find).with(mock_shift.id, anything) { mock_shift }
    {
      :section => mock_section,
      :shift => mock_shift
    }
  end
  let(:section_shift) { SectionShift.create!(valid_attributes) }

  # database

  it { should have_db_column(:section_id).with_options(:null => false) }

  it { should have_db_column(:shift_id).with_options(:null => false) }

  it { should have_db_column(:position).with_options(:null => false, :default => 1) }

  it { should have_db_index([:section_id, :shift_id]).unique(true) }

  it { should have_db_index(:section_id) }

  it { should have_db_index(:shift_id) }

  # associations
  
  it { should have_many(:shift_tag_assignments).dependent(:destroy) }

  it { should have_many(:shift_tags).through(:shift_tag_assignments) }

  it { should belong_to(:section) }

  it { should belong_to(:shift) }

  it { should belong_to(:call_shift) }

  it { should belong_to(:vacation_shift) }

  it { should belong_to(:meeting_shift) }

  # validations

  it { should validate_presence_of(:section) }

  it { should validate_presence_of(:shift) }

  it { should validate_presence_of(:position) }

  it { should validate_associated(:section) }

  it { should validate_associated(:shift) }

  it { should allow_value("#0369bf").for(:display_color) }

  it { should allow_value("#000").for(:display_color) }

  it { should allow_value(nil).for(:display_color) }

  it { should_not allow_value("ffffff").for(:display_color) }

  it { should_not allow_value("#qwerty").for(:display_color) }

  # scopes

  describe ".active_as_of(:cutoff_date)" do

    it "returns shifts with nil retired_on" do
      section_shift.update_attributes({ :retired_on => nil })
      SectionShift.active_as_of(Date.today).should include(section_shift)
    end

    it "returns shifts with retired_on > cutoff_date" do
      section_shift.update_attributes({ :retired_on => Date.tomorrow })
      SectionShift.active_as_of(Date.yesterday).should include(section_shift)
    end

    it "does not return shifts with retired_on < cutoff_date" do
      section_shift.update_attributes({ :retired_on => Date.yesterday })
      SectionShift.active_as_of(Date.tomorrow).should_not include(section_shift)
    end
  end

  describe ".retired_as_of(:cutoff_date)" do

    it "does not return section_shifts with retired_on == nil" do
      section_shift.update_attributes({ :retired_on => nil })
      SectionShift.retired_as_of(Date.today).should_not include(section_shift)
    end

    it "returns section_shifts with retired_on < cutoff_date" do
      section_shift.update_attributes({ :retired_on => Date.yesterday })
      SectionShift.retired_as_of(Date.tomorrow).should include(section_shift)
    end

    it "does not return section_shifts with retired_on > cutoff_date" do
      section_shift.update_attributes({ :retired_on => Date.tomorrow })
      SectionShift.retired_as_of(Date.yesterday).should_not include(section_shift)
    end
  end

  # methods
 
  describe "#retire=(:value)" do

    context "value is like true" do

      it "retired_on is set to today" do
        section_shift.retire = "1"
        section_shift.retired_on.should == Date.today
      end
    end
  end
end
