require 'spec_helper'

describe ShiftTagAssignment do

  let(:mock_tag) { mock_model(ShiftTag) }
  let(:mock_section_shift) { mock_model(SectionShift) }
  let(:valid_attributes) do
    {
      :shift_tag => mock_tag,
      :section_shift => mock_section_shift
    }
  end
  let(:assignment) { ShiftTagAssignment.create!(valid_attributes) }

  before(:each) do
    ShiftTag.stub!(:find).with(mock_tag.id, anything) { mock_tag }
    SectionShift.stub!(:find).with(mock_section_shift.id, anything).
      and_return(mock_section_shift)
  end

  subject { assignment }

  # database

  it { should have_db_column(:shift_tag_id).with_options(:null => false) }

  it { should have_db_column(:section_shift_id).with_options(:null => false) }

  it { should have_db_index(:shift_tag_id) }

  it { should have_db_index(:section_shift_id) }

  it { should have_db_index([:section_shift_id, :shift_tag_id]).unique(true) }

  # associations

  it { should belong_to(:shift_tag) }

  it { should belong_to(:section_shift) }

  # validations

  it { should validate_presence_of(:shift_tag) }

  it { should validate_presence_of(:section_shift) }

  it { should validate_uniqueness_of(:section_shift_id).scoped_to(:shift_tag_id) }
end
