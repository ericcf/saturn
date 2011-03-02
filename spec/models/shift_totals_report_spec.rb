require 'spec_helper'

describe ShiftTotalsReport do

  let(:today) { Date.today }
  let(:valid_attributes) do
    {
      :start_date => today.to_s,
      :end_date => today.to_s
    }
  end
  let(:report) { ShiftTotalsReport.new(valid_attributes) }

  subject { report }

  it { should be_valid }
end
