class MembershipsController < ApplicationController
  include SectionResourceController

  before_filter :authenticate_user!, :except => :index

  def index
    @members_by_group = @section.members_by_group
  end

  def manage_new
    authorize! :update, @section
    memberships = @section.memberships.map(&:physician_id)
    @physicians = Physician.all.select do |physician|
      !memberships.include?(physician.id)
    end
  end

  def manage
    authorize! :update, @section
    @members_by_group = @section.members_by_group
  end
end
