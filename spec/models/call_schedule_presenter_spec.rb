require 'spec_helper'

describe CallSchedulePresenter do

  let(:today) { Date.today }
  let(:valid_attributes) do
    {
      :dates => [today]
    }
  end
  let(:schedule) { CallSchedulePresenter.new(valid_attributes) }

  subject { schedule }

  it { should be_valid }

  # validations

  it "validates presence of dates" do
    CallSchedulePresenter.new(:dates => nil).
      should have(1).error_on(:dates)
  end
end
