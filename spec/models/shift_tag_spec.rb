require 'spec_helper'

describe ShiftTag do

  let(:mock_section) { stub_model(Section) }
  let(:valid_attributes) do
    {
      :section => mock_section,
      :title => "value for title"
    }
  end
  let(:shift_tag) { ShiftTag.create!(valid_attributes) }

  before(:each) do
    Section.stub!(:find).with(mock_section.id, anything) { mock_section }
  end
  
  subject { shift_tag }

  # database

  it { should have_db_column(:section_id).
    with_options(:null => false) }

  it { should have_db_index(:section_id) }

  it { should have_db_column(:title).with_options(:null => false) }

  it { should have_db_index([:section_id, :title]).unique(true) }

  # associations

  it { should have_many(:assignments).dependent(:destroy) }

  it { should have_many(:section_shifts).through(:assignments) }

  it { should have_one(:daily_shift_count_rule).dependent(:destroy) }

  it { should belong_to(:section) }

  # validations

  it { should validate_presence_of(:section) }

  it { should validate_presence_of(:title) }

  it { should validate_uniqueness_of(:title).scoped_to(:section_id) }

  # callbacks

  context "#destroy is called when assignments are associated" do
  
    it "returns false" do
      shift_tag.stub!(:assignments).and_return([mock("assignment")])
      shift_tag.destroy.should be_false
    end
  end

  context "#destroy is called when no assignments are associated" do

    it "returns true" do
      mock_assignments = mock("assignments", :delete_all => true).as_null_object
      shift_tag.stub!(:assignments) { mock_assignments }
      shift_tag.destroy.should be_true
    end
  end

  # methods

  describe "#clear_assignments=(:value)" do

    context "value is like true" do

      it "clears all assignments" do
        mock_assignments = mock("assignments")
        shift_tag.stub!(:assignments).and_return(mock_assignments)
        mock_assignments.should_receive(:clear)
        shift_tag.clear_assignments = "1"
      end
    end
  end
end
