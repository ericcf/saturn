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
      assignment = stub_model(Assignment, :physician => physician)
      Physician.with_assignments([assignment]).map(&:id).
        should include(physician.id)
    end
  end
end
