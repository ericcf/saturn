RadDirectory::Person.class_eval do
  attr_accessible []

  has_many :assignments, :foreign_key => :physician_id, :dependent => :destroy
  has_many :meeting_requests, :foreign_key => :requester_id,
    :dependent => :destroy
  has_many :vacation_requests, :foreign_key => :requester_id,
    :dependent => :destroy
  has_one :names_alias, :class_name => "PhysicianAlias",
    :foreign_key => :physician_id
  has_many :section_memberships, :foreign_key => :physician_id,
    :dependent => :destroy

  def sections
    ::Section.find(section_memberships.map(&:section_id))
  end

  def initials
    return names_alias.initials if names_alias && names_alias.initials
    given_name.first + (family_name && family_name.first || "")
  end

  def short_name
    names_alias && names_alias.short_name ||
    "#{given_name[0, 1]}. #{family_name}".strip
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
end

class Physician < RadDirectory::Person

  scope :with_assignments, lambda { |assignments|
    where(:id => assignments.map(&:physician_id))
  }

  def self.section_members
    where(:id => SectionMembership.all.map(&:physician_id).uniq)
  end
end
