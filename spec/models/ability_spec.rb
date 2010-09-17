require 'spec_helper'
require 'cancan/matchers'

describe Ability do

  subject { Ability.new(mock_model(User, :admin? => true)) }

  it { should be_able_to(:manage, WeeklySchedule) }

  it { should be_able_to(:manage, SectionMembership) }

  it { should be_able_to(:manage, Shift) }

  it { should be_able_to(:manage, ShiftTag) }

  it { should be_able_to(:manage, Person) }

  it { should be_able_to(:manage, Section) }

  it { should be_able_to(:manage, Rotation) }

  it { should be_able_to(:manage, User) }
end
