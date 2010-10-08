class Section < ActiveRecord::Base

  SCHEDULE_GROUPS = %w[Faculty Fellows Residents]

  has_many :shift_tags, :dependent => :destroy
  accepts_nested_attributes_for :shift_tags, :allow_destroy => true
  has_many :memberships,
    :class_name => 'SectionMembership',
    :dependent => :destroy
  accepts_nested_attributes_for :memberships, :allow_destroy => true
  has_many :members, :through => :memberships, :source => :person
  has_many :weekly_schedules, :dependent => :destroy
  has_many :shifts, :dependent => :destroy
  accepts_nested_attributes_for :shifts
  has_many :vacation_requests, :dependent => :destroy

  validates :title, :presence => true, :uniqueness => true

  before_validation { clean_attributes :title, :description }

  def physician_members
    physician_groups = Group.find_all_by_title(SCHEDULE_GROUPS)
    members.select do |person|
      physician_groups.any? { |group| person.member_of_group? group }
    end
  end

  # returns the members of this section grouped by SCHEDULE_GROUPS, i.e.:
  # { "Faculty" => [p1, p2], "Fellows" => [p3, p4], "Residents" => [p5, p6] }
  def members_by_group
    grouped_people = {}
    Group.find_all_by_title(SCHEDULE_GROUPS).each do |group|
      grouped_people[group.title] = members.select do |person|
        person.member_of_group? group
      end
    end
    grouped_people
  end
end
