RadDirectory::Person.class_eval do
  attr_accessible []

  has_many :assignments, :foreign_key => :physician_id, :dependent => :destroy
  has_one :names_alias, :class_name => "PhysicianAlias",
    :foreign_key => :physician_id
  has_many :section_memberships, :foreign_key => :physician_id,
    :dependent => :destroy

  def sections
    Section.where(:id => section_memberships.map(&:section_id))
  end

  def published_shifts_on_date(date)
    assignments.where(:date => date).includes(:shift).published.map(&:shift)
  end

  def initials
    return names_alias.initials if names_alias && names_alias.initials
    given_name.first + (family_name && family_name.first || "")
  end

  def short_name
    return names_alias.short_name if names_alias && names_alias.short_name
    ["#{given_name.split("").first}.", family_name].compact.join(" ")
  end
end

class Physician < RadDirectory::Person

  def self.section_members
    where(:id => SectionMembership.all.map(&:physician_id).uniq)
  end
end
