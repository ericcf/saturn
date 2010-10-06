class SiteStatisticsController < ApplicationController

  def index
    @assignment_count = Assignment.count
    @assignments_last_updated = @assignment_count > 0 ?
      Assignment.order(:updated_at).last.updated_at : nil
    @section_count = Section.count
    @sections_last_updated = @section_count > 0 ?
      Section.order(:updated_at).last.updated_at : nil
  end
end
