require 'spec_helper'

describe PhysicianSchedule do

  let(:today) { Date.today }
  let(:mock_physician) { stub_model(Physician) }
  let(:valid_attributes) do
    {
      :start_date => today,
      :number_of_days => 1,
      :physician => mock_physician
    }
  end
  let(:schedule) { PhysicianSchedule.new(valid_attributes) }

  subject { schedule }

  it { should be_valid }

  # validations

  it "validates presence of start_date" do
    PhysicianSchedule.new(:start_date => nil).
      should have(1).error_on(:start_date)
  end

  it "validates presence of number_of_days" do
    PhysicianSchedule.new(:number_of_days => nil).
      should have(1).error_on(:number_of_days)
  end

  it "validates presence of physician" do
    PhysicianSchedule.new(:physician => nil).
      should have(1).error_on(:physician)
  end

  describe "#dates" do

    it "returns dates based on the start_date and number_of_days attributes" do
      schedule.dates.should == [today]
    end
  end
end
