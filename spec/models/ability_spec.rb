require 'spec_helper'
require 'cancan/matchers'

describe Ability do

  subject { Ability.new(User.new) }

  it { should be_able_to(:manage, WeeklySchedule) }

  it { should be_able_to(:manage, SectionMembership) }

  it { should be_able_to(:manage, Shift) }

  it { should be_able_to(:manage, ShiftTag) }

  it { should be_able_to(:manage, Person) }

  it { should be_able_to(:manage, Section) }
end
