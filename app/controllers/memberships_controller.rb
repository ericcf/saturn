class MembershipsController < ApplicationController

  before_filter :find_section

  def new
    schedule_groups = Group.find_all_by_title(Section::SCHEDULE_GROUPS)
    @people = Person.current.includes([:section_memberships, :memberships]).select do |p|
      !p.section_ids.include?(@section.id) &&
        schedule_groups.any? { |g| p.member_of_group? g }
    end
    @membership = SectionMembership.new(:section_id => @section.id)
  end

  def create
    @membership = SectionMembership.new(params[:section_membership])

    if @section.memberships << @membership
      return(redirect_to section_path(@section))
    end
    flash[:error] = @membership.errors.full_messages.join(", ")
    render :new
  end

  private

  def find_section
    section_id = params[:section_id]
    return(redirect_to(sections_path)) unless section_id
    @section = Section.find(section_id)
  end
end
