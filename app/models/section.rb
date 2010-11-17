class Section < ActiveRecord::Base

  SCHEDULE_GROUPS = %w[Faculty Fellows Residents]

  has_many :shift_tags, :dependent => :destroy
  accepts_nested_attributes_for :shift_tags, :allow_destroy => true
  has_many :memberships,
    :class_name => 'SectionMembership',
    :dependent => :destroy
  accepts_nested_attributes_for :memberships, :allow_destroy => true
  has_many :weekly_schedules, :dependent => :destroy
  has_many :assignments, :through => :weekly_schedules
  has_many :shifts, :dependent => :destroy
  accepts_nested_attributes_for :shifts
  has_many :vacation_requests, :dependent => :destroy
  has_one :weekly_shift_duration_rule, :dependent => :destroy
  accepts_nested_attributes_for :weekly_shift_duration_rule
  has_many :daily_shift_count_rules, :dependent => :destroy
  accepts_nested_attributes_for :daily_shift_count_rules

  validates :title, :presence => true, :uniqueness => true

  before_validation { clean_text_attributes :title, :description }

  def members
    Physician.where(:id => memberships.map(&:physician_id))
  end

  # returns the members of this section grouped by SCHEDULE_GROUPS, i.e.:
  # { "Faculty" => [p1, p2], "Fellows" => [p3, p4], "Residents" => [p5, p6] }
  def members_by_group
    physicians = members.includes(:names_alias, :memberships)
    grouped_people = {}
    RadDirectory::Group.find_all_by_title(SCHEDULE_GROUPS).each do |group|
      grouped_people[group.title] = physicians.select do |physician|
        physician.in_group? group
      end
    end
    grouped_people
  end
end
