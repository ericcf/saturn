class SiteStatisticsController < ApplicationController

  def index
    @assignment_count = Assignment.count
    @assignments_last_updated = Assignment.order(:updated_at).last.updated_at
    @section_count = Section.count
    @sections_last_updated = Section.order(:updated_at).last.updated_at
  end
end
