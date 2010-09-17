class Ability

  include CanCan::Ability

  def initialize(user)
    return if user.nil?
    if user.admin?
      can :manage, [WeeklySchedule, SectionMembership, Shift, ShiftTag, Person,
        Section, Rotation, User]
    end
  end
end
