require 'spec_helper'

describe Physician do

  # associations

  it { should have_many(:section_memberships).dependent(:destroy) }

  it { should have_many(:assignments).dependent(:destroy) }

  it { should have_many(:meeting_requests).dependent(:destroy) }

  it { should have_many(:vacation_requests).dependent(:destroy) }

  it { should have_one(:names_alias) }

  # scopes

  describe ".with_assignments(:assignments)" do

    it "returns physicians associated with the assignments" do
      physician = Factory(:physician)
      assignment = Factory(:assignment, :physician => physician)
      Physician.with_assignments([assignment]).map(&:id).
        should include(physician.id)
    end
  end

  # methods

  describe "#published_shifts_on_date(:date)" do

    it "returns shifts from published assignments on the requested date" do
      schedule = Factory(:published_weekly_schedule)
      assignment = Factory(:assignment, :weekly_schedule => schedule)
      assignment.physician.published_shifts_on_date(assignment.date).
        should include(assignment.shift)
    end
  end
end
