module SectionResourceController

  def self.included(base)
    base.before_filter :find_section
    base.layout "section"

  end

  private

  def find_section
    section_id = params[:section_id]
    return(redirect_to(sections_path)) unless section_id
    @section = Section.find(section_id)
  end
end
