class MembershipsController < ApplicationController

  before_filter :authenticate_user!
  before_filter { authorize! :manage, SectionMembership }
  before_filter :find_section

  def index
    @members_by_group = @section.members_by_group
  end

  def manage_new
    schedule_groups = RadDirectory::Group.find_all_by_title(Section::SCHEDULE_GROUPS)
    memberships = @section.memberships.map(&:physician_id)
    @physicians = Physician.current.includes(:memberships).select do |p|
      !memberships.include?(p.id) &&
        schedule_groups.any? { |g| p.in_group? g }
    end
  end

  def manage
    @members_by_group = @section.members_by_group
  end

  private

  def find_section
    section_id = params[:section_id]
    return(redirect_to(sections_path)) unless section_id
    @section = Section.find(section_id)
  end
end
