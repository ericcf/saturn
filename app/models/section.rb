class Section < ActiveRecord::Base

  attr_accessible :title, :memberships_attributes, :shifts_attributes,
    :shift_tags_attributes, :administrator_ids, :section_shifts_attributes,
    :weekly_shift_duration_rule_attributes, :daily_shift_count_rules_attributes

  SCHEDULE_GROUPS = %w[Faculty Fellows Residents]

  has_friendly_id :title, :use_slug => true

  with_options :dependent => :destroy do |assoc|
    assoc.has_many :shift_tags
    assoc.has_many :memberships,:class_name => 'SectionMembership'
    assoc.has_many :weekly_schedules
    assoc.has_many :section_shifts
    assoc.has_one :weekly_shift_duration_rule
    assoc.has_many :daily_shift_count_rules
    assoc.has_one :section_role_assignment
  end
  has_many :shifts, :through => :section_shifts
  has_many :call_shifts, :through => :section_shifts
  has_many :vacation_shifts, :through => :section_shifts
  has_many :meeting_shifts, :through => :section_shifts
  has_many :shift_tag_assignments, :through => :section_shifts
  has_one :admin_role, :through => :section_role_assignment, :source => :role
  accepts_nested_attributes_for :shift_tags, :allow_destroy => true
  accepts_nested_attributes_for :memberships, :allow_destroy => true
  accepts_nested_attributes_for :shifts
  accepts_nested_attributes_for :call_shifts
  accepts_nested_attributes_for :vacation_shifts
  accepts_nested_attributes_for :meeting_shifts
  accepts_nested_attributes_for :section_shifts
  accepts_nested_attributes_for :weekly_shift_duration_rule
  accepts_nested_attributes_for :daily_shift_count_rules

  validates :title, :presence => true, :uniqueness => true

  before_validation { clean_text_attributes :title }

  def assignments
    Assignment.includes(:shift).where(:shift_id => shifts.map(&:id))
  end

  def assignment_requests
    AssignmentRequest.includes(:shift).where(:shift_id => shifts.map(&:id))
  end

  def active_shifts(options = nil)
    date = options.nil? ? Date.today : options[:as_of]
    Shift.joins(:section_shifts).merge(section_shifts.active_as_of(date))
  end

  def retired_shifts_as_of(date)
    Shift.joins(:section_shifts).merge(section_shifts.retired_as_of(date))
  end

  def tags_for_shift(shift)
    @shift_tag_by_id ||= shift_tags.scoped.hash_by_id
    @shift_tags_by_shift_id ||= shift_tag_assignments.
      includes(:section_shift, :shift_tag).
      each_with_object({}) do |assignment, hsh|
        hsh[assignment.section_shift.shift_id] ||= []
        hsh[assignment.section_shift.shift_id] << assignment.shift_tag
      end
    @shift_tags_by_shift_id[shift.id] || []
  end

  def published_assignments_by_dates(dates)
    published_schedules = weekly_schedules.published.include_dates dates
    published_dates = published_schedules.map(&:dates).flatten
    assignments.where(:date => published_dates)
  end

  def members
    Physician.where(:id => member_ids)
  end

  def member_ids
    memberships.map(&:physician_id)
  end

  # returns the members of this section grouped by SCHEDULE_GROUPS, i.e.:
  # { "Faculty" => [p1, p2], "Fellows" => [p3, p4], "Residents" => [p5, p6] }
  def members_by_group
    physicians = members.includes(:names_alias, :memberships)
    groups = RadDirectory::Group.find_all_by_title(SCHEDULE_GROUPS)
    groups.each_with_object({}) do |group, grouped_members|
      grouped_members[group.title] = physicians.select do |physician|
        physician.in_group? group
      end
    end
  end

  def members_by_group_json
    [
      "\"groups\":[",
        members_by_group.map do |group_title, physicians|
          [
          "{",
            "\"title\":\"#{group_title}\",",
            "\"physicians\":[",
              physicians.map do |physician|
                physician.to_json
              end.join(","),
            "]",
          "}"
          ].join("")
        end.join(","),
      "]"
    ].join("")
  end

  def members_json
    [
      "\"physicians\":[",
        members.includes(:names_alias).map do |physician|
          physician.to_json
        end.join(","),
      "]"
    ].join("")
  end

  def create_admin_role
    return admin_role unless admin_role.blank?
    manage_section_permission = Deadbolt::Permission.
      find_or_create_by_action_and_target_type("manage", "Section")
    role = manage_section_permission.roles.
      find_or_create_by_name("#{title} Administrator")
    role.role_permissions.first.update_attributes(:target_id => id)
    create_section_role_assignment(:role => role)
    role
  end

  def administrators
    return [] if admin_role.blank?
    admin_role.users
  end

  def administrator_emails
    administrators.map(&:email)
  end

  def administrator_ids
    administrators.map(&:id)
  end

  def administrator_ids=(ids)
    create_admin_role.user_ids = ids
  end
end
