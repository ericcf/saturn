require 'spec_helper'

describe ::Logical::YearlySectionSchedule do

  let(:this_year) { Date.today.year }
  let(:valid_attributes) do
    {
      :year => this_year
    }
  end
  let(:yearly_schedule) do
    ::Logical::YearlySectionSchedule.new(valid_attributes)
  end

  subject { yearly_schedule }

  # validations

  it "validates the presence of year" do
    ::Logical::YearlySectionSchedule.new(:year => nil).
      should have(1).error_on(:year)
  end

  it "validates the presence of section" do
    ::Logical::YearlySectionSchedule.new(:section => nil).
      should have(1).error_on(:section)
  end
end
