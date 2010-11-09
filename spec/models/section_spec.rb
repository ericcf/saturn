require 'spec_helper'

describe Section do

  before(:each) do
    Section.create!(:title => "Foo").should be_valid
  end

  # database

  it { should have_db_column(:title).with_options(:null => false) }

  it { should have_db_index(:title).unique(true) }

  # associations

  it { should have_many(:shift_tags).dependent(:destroy) }

  it { should have_many(:memberships).dependent(:destroy) }

  it { should have_many(:weekly_schedules).dependent(:destroy) }

  it { should have_many(:shifts).dependent(:destroy) }

  it { should have_many(:vacation_requests).dependent(:destroy) }

  it { should have_one(:weekly_shift_duration_rule).dependent(:destroy) }

  it { should have_many(:daily_shift_count_rules).dependent(:destroy) }

  # validations

  it { should validate_presence_of(:title) }

  it { should validate_uniqueness_of(:title) }

  # attribute cleanup

  it { should clean_text_attribute(:title) }

  it { should clean_text_attribute(:description) }
end
