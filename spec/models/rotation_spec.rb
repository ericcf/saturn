require 'spec_helper'

describe Rotation do

  let(:valid_attributes) do
    {
      :title => "valid title"
    }
  end
  let(:rotation) { Rotation.create!(valid_attributes) }

  subject { rotation }

  # database

  it { should have_db_column(:title).with_options(:null => false) }

  # validation

  it { should validate_presence_of(:title) }

  # attribute cleaning

  it { should clean_text_attribute(:title) }

  it { should clean_text_attribute(:description) }

end
