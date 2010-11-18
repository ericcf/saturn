class MembershipsController < ApplicationController
  include SectionResourceController

  before_filter :authenticate_user!, :except => :index

  def index
    @members_by_group = @section.members_by_group
  end

  def manage_new
    authorize! :update, @section
    schedule_groups = RadDirectory::Group.find_all_by_title(Section::SCHEDULE_GROUPS)
    memberships = @section.memberships.map(&:physician_id)
    @physicians = Physician.current.includes(:memberships).select do |p|
      !memberships.include?(p.id) &&
        schedule_groups.any? { |g| p.in_group? g }
    end
  end

  def manage
    authorize! :update, @section
    @members_by_group = @section.members_by_group
  end
end
