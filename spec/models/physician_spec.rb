require 'spec_helper'

describe Physician do

  # associations

  it { should have_many(:section_memberships).dependent(:destroy) }

  it { should have_many(:assignments).dependent(:destroy) }

  it { should have_one(:names_alias) }
end
