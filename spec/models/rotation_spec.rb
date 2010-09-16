require 'spec_helper'

describe Rotation do

  before(:each) do
    @valid_attributes = {
      :title => "valid title"
    }
    @rotation = Rotation.create(@valid_attributes)
    @rotation.should be_valid
  end

  # database

  it { should have_db_column(:title).with_options(:null => false) }

  # validation

  it { should validate_presence_of(:title) }

  # attribute cleaning

  it { should clean_attribute(:title) }

  it { should clean_attribute(:description) }

end
