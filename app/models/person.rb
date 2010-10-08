require 'formatters'

class Person < Contact

  include Formatters::Person

  has_many :section_memberships, :dependent => :destroy
  has_many :sections, :through => :section_memberships
  has_many :assignments
  has_many :memberships, :foreign_key => :contact_id
  has_many :groups, :through => :memberships
  has_one :names_alias, :class_name => "PersonAlias"
  accepts_nested_attributes_for :names_alias

  attr_accessible :names_alias_attributes

  scope :physicians, lambda {
    includes(:groups).
    where("groups.title in (?)", Section::SCHEDULE_GROUPS)
  }
  scope :current, lambda {
    where("(employment_ends_on is null or employment_ends_on > ?) and (employment_starts_on is null or employment_starts_on <= ?)", Date.today, Date.today)
  }
  scope :name_like, lambda { |query|
    where("contacts.given_name like ? or contacts.other_given_names like ? or contacts.family_name like ?", "%#{query}%", "%#{query}%", "%#{query}%")
  }
  default_scope current.physicians.order("family_name")

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

  def member_of_group?(group_or_id)
    group_id = group_or_id.is_a?(Group) ? group_or_id.id : group_or_id
    memberships.map(&:group_id).include? group_id
  end
end
