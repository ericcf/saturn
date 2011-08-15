class Physician < RadDirectoryClient::Physician

  def section_memberships
    ::SectionMembership.where :physician_id => id
  end

  def sections
    ::Section.where :id => section_memberships.map(&:section_id)
  end

  def shifts
    sections.map(&:shifts).flatten
  end

  def assignment_requests
    ::AssignmentRequest.where :requester_id => id
  end

  def names_alias
    ::PhysicianAlias.find_by_physician_id id
  end

  def primary_email
    emails.count > 0 && emails.first.value
  end

  def short_name
    names_alias && names_alias.short_name ||
    "#{given_name[0, 1]}. #{family_name}".strip
  end

  def initials
    return names_alias.initials if names_alias && names_alias.initials
    given_name.first + (family_name && family_name.first || "")
  end

  def in_group?(group_title)
    groups.map(&:title).include? group_title
  end

  def as_json(options = {})
    super(options.merge(
          :only => [:id],
          :methods => [:short_name]
    ))
  end
end
