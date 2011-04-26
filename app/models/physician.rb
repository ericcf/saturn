RadDirectory::Physician.class_eval do

  attr_accessible []

  with_options :dependent => :destroy do |assoc|
    assoc.has_many :assignments, :foreign_key => :physician_id
    assoc.has_many :assignment_requests, :foreign_key => :requester_id
    assoc.has_one :names_alias, :class_name => "PhysicianAlias",
      :foreign_key => :physician_id
    assoc.has_many :section_memberships, :foreign_key => :physician_id
  end

  def sections
    ::Section.where(:id => section_memberships.map(&:section_id))
  end

  def shifts
    ::Shift.includes(:sections).merge(sections)
  end

  def initials
    return names_alias.initials if names_alias && names_alias.initials
    given_name.first + (family_name && family_name.first || "")
  end

  def short_name
    names_alias && names_alias.short_name ||
    "#{given_name[0, 1]}. #{family_name}".strip
  end

  def work_email
    email = emails.find_by_category("work")
    email.present? ? email.value : ""
  end

  def as_json(options = {})
    {
      :id => id,
      :short_name => short_name
    }
  end

  def to_json
    [
      "{\"physician\":",
        "{",
          "\"id\":#{id},",
          "\"short_name\":\"#{short_name}\"",
        "}",
      "}"
    ].join("")
  end

  scope :with_assignments, lambda { |assignments|
    where(:id => assignments.map(&:physician_id))
  }

  def self.section_members
    where(:id => SectionMembership.all.map(&:physician_id).uniq)
  end
end

class Physician < RadDirectory::Physician
end
