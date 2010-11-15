class SiteStatisticsController < ApplicationController

  def index
    @assignment_count = Assignment.count
    @recent_assignments = Assignment.order("updated_at desc").limit(5)
    @section_count = Section.count
    @sections = Section.order("updated_at desc")
  end
end
