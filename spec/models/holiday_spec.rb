require 'spec_helper'

describe Holiday do

  let(:valid_attributes) do
    {
      :date => Date.today,
      :title => "Pee Wee's Birthday"
    }
  end
  let(:holiday) { Holiday.create!(valid_attributes) }

  # database
  
  it { should have_db_column(:date).with_options(:null => false) }

  it { should have_db_column(:title).with_options(:null => false) }

  it { should have_db_index(:date) }

  # validations

  it { should validate_presence_of(:date) }

  it { should validate_presence_of(:title) }
end
