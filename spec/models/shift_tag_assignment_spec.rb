require 'spec_helper'

describe ShiftTagAssignment do

  before(:each) do
    mock_tag = mock_model(ShiftTag)
    ShiftTag.stub!(:find).with(mock_tag.id, anything).and_return(mock_tag)
    mock_shift = mock_model(Shift)
    Shift.stub!(:find).with(mock_shift.id, anything).and_return(mock_shift)
    @valid_attributes = {
      :shift_tag_id => mock_tag.id,
      :shift_id => mock_shift.id
    }
    ShiftTagAssignment.create(@valid_attributes).should be_valid
  end

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
