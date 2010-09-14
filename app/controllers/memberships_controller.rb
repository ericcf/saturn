class MembershipsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_section

  def index
    @members_by_group = @section.members_by_group
    authorize! :manage, SectionMembership
  end

  def new
    schedule_groups = Group.find_all_by_title(Section::SCHEDULE_GROUPS)
    @people = Person.current.includes([:section_memberships, :memberships]).select do |p|
      !p.section_ids.include?(@section.id) &&
        schedule_groups.any? { |g| p.member_of_group? g }
    end
    authorize! :manage, SectionMembership
  end

  private

  def find_section
    section_id = params[:section_id]
    return(redirect_to(sections_path)) unless section_id
    @section = Section.find(section_id)
  end
end
