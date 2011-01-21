module ReportsHelper

  def physician_groups
    @physician_groups ||= RadDirectory::Group.find_all_by_title(Section::SCHEDULE_GROUPS)
  end
end
