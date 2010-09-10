require 'spec_helper'

describe ShiftTag do

  before(:each) do
    mock_section = mock_model(Section)
    Section.stub!(:find).with(mock_section.id, anything).
      and_return(mock_section)
    @valid_attributes = {
      :section_id => mock_section.id,
      :title => "value for title"
    }
    @shift_tag = ShiftTag.create(@valid_attributes)
    @shift_tag.should be_valid
  end

  # database

  it { should have_db_column(:section_id).
    with_options(:null => false) }

  it { should have_db_index(:section_id) }

  it { should have_db_column(:title).with_options(:null => false) }

  it { should have_db_index([:section_id, :title]).unique(true) }

  # associations

  it { should have_many(:assignments).dependent(:destroy) }

  it { should have_many(:shifts).through(:assignments) }

  it { should belong_to(:section) }

  # validations

  it { should validate_presence_of(:section) }

  it { should validate_presence_of(:title) }

  it { should validate_uniqueness_of(:title).scoped_to(:section_id) }

  it { should allow_value("ffffff").for(:display_color) }

  it { should_not allow_value("qwerty").for(:display_color) }

  # callbacks

  context "#destroy is called when assignments are associated" do
  
    it "returns false" do
      @shift_tag.stub!(:assignments).and_return([mock("assignment")])
      @shift_tag.destroy.should be_false
    end
  end

  context "#destroy is called when no assignments are associated" do

    it "returns true" do
      @shift_tag.stub!(:assignments).and_return([])
      @shift_tag.destroy.should be_true
    end
  end

  # methods

  describe "#clear_assignments=(:value)" do

    context "value is like true" do

      it "clears all assignments" do
        mock_assignments = mock("assignments")
        @shift_tag.stub!(:assignments).and_return(mock_assignments)
        mock_assignments.should_receive(:clear)
        @shift_tag.clear_assignments = "1"
      end
    end
  end
end
