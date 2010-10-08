require 'spec_helper'

describe Person do

  # associations

  it { should have_many(:section_memberships).dependent(:destroy) }

  it { should have_many(:sections).through(:section_memberships) }

  it { should have_many(:memberships) }

  it { should have_one(:names_alias) }

  # attributes

  it { should allow_mass_assignment_of(:names_alias_attributes) }
end
