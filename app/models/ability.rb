class Ability

  include CanCan::Ability

  def initialize(user)
    if user
      can :manage, [WeeklySchedule, SectionMembership, Shift, ShiftTag, Person,
        Section, Rotation]
    end
  end
end
