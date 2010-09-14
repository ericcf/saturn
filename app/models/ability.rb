class Ability

  include CanCan::Ability

  def initialize(user)
    if user
      can :manage, [WeeklySchedule, SectionMembership, Shift, ShiftTag, Person,
        Section]
    end
  end
end
