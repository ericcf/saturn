require 'spec_helper'

describe ::Logical::MonthlySectionSchedule do

  let(:today) { Date.today }
  let(:this_year) { today.year }
  let(:this_month) { today.month }
  let(:mock_section) { mock_model(Section) }
  let(:valid_attributes) do
    {
      :year => this_year,
      :month => this_month,
      :section => mock_section
    }
  end
  let(:monthly_schedule) do
    ::Logical::MonthlySectionSchedule.new(valid_attributes)
  end

  subject { monthly_schedule }

  it { should be_valid }

  # validations

  it "validates the presence of year" do
    ::Logical::MonthlySectionSchedule.new(:year => nil).
      should have(1).error_on(:year)
  end

  it "validates the presence of month" do
    ::Logical::MonthlySectionSchedule.new(:month => nil).
      should have(1).error_on(:month)
  end

  it "validates the presence of section" do
    ::Logical::MonthlySectionSchedule.new(:section => nil).
      should have(1).error_on(:section)
  end
end
