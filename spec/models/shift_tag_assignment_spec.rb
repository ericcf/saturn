require 'spec_helper'

describe ShiftTagAssignment do

  let(:mock_tag) { stub_model(ShiftTag) }
  let(:mock_shift) { stub_model(Shift) }
  let(:valid_attributes) do
    {
      :shift_tag => mock_tag,
      :shift => mock_shift
    }
  end
  let(:assignment) { ShiftTagAssignment.create!(valid_attributes) }

  before(:each) do
    ShiftTag.stub!(:find).with(mock_tag.id, anything) { mock_tag }
    Shift.stub!(:find).with(mock_shift.id, anything) { mock_shift }
  end

  subject { assignment }

  # database

  it { should have_db_column(:shift_tag_id).with_options(:null => false) }

  it { should have_db_column(:shift_id).with_options(:null => false) }

  it { should have_db_index(:shift_tag_id) }

  it { should have_db_index(:shift_id) }

  it { should have_db_index([:shift_id, :shift_tag_id]).unique(true) }

  # associations

  it { should belong_to(:shift_tag) }

  it { should belong_to(:shift) }

  # validations

  it { should validate_presence_of(:shift_tag) }

  it { should validate_presence_of(:shift) }

  it { should validate_uniqueness_of(:shift_id).scoped_to(:shift_tag_id) }
end
