module NavigationHelpers
  
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'

    # users
    when /login/
      new_user_session_path
    when /logout/
      destroy_user_session_path

    # administration
    when /physicians page/
      physicians_path
    when /new physician alias page for \"([^ ]+) ([^"]+)\"/
      physician = Physician.find_by_given_name_and_family_name($1, $2)
      new_physician_physician_alias_path(physician)
    when /edit physician alias page for \"([^ ]+) ([^"]+)\"/
      physician = Physician.find_by_given_name_and_family_name($1, $2)
      edit_physician_physician_alias_path(physician)
    when /the new section page/
      new_section_path
    when /the edit section page for \"([^"]+)\"/
      edit_section_path(find_section($1))

    # global
    when /the physician schedule search page/
      search_physicians_path

    # schedules
    when /the weekly call schedule page for the week beginning (\d{4})-(\d{2})-(\d{2})/
      weekly_call_schedule_path(:date => { :year => $1, :month => $2, :day => $3 })
    when /the weekly section schedule page for \"([^"]+)\" on (\d{4})-(\d{2})-(\d{2})/
      weekly_section_schedule_path(find_section($1), :date => { :year => $2, :month => $3, :day => $4 })
    when /the assignment requests page for the \"([^"]+)\" section/
      section_assignment_requests_path(find_section($1))
    when /the new assignment request page for the \"([^"]+)\" section/
      new_section_assignment_request_path(find_section($1))

    # personal
    when /the personal dashboard for \"([^ ]+) ([^"]+)\" on (\d{4})-(\d{2})-(\d{2})/
      physician = Physician.find_by_given_name_and_family_name($1, $2)
      schedule_physician_path(physician, :date => { :year => $3, :month => $4, :day => $5 })

    # reports
    when /the reports page for \"([^"]+)\"/
      section_shift_totals_path(find_section($1))
    when /the shift totals search page for \"([^"]+)\"/
      search_shift_totals_section_reports_path(find_section($1))
    when /the shift totals report page for \"([^"]+)\"/
      shift_totals_report_section_reports_path(find_section($1))
    when /the totals by day page for the \"([^"]+)\" shift in \"([^"]+)\"/
      totals_by_day_section_reports_path(find_section($2), find_shift($1))
    when /edit weekly schedule page for \"([^"]+)\"(?: on (\d{4}-\d{2}-\d{2}))?/
      section = find_section($1)
      if $2
        edit_section_weekly_schedules_path(section, :anchor => $2)
      else
        edit_section_weekly_schedules_path(section)
      end

    # section management
    when /manage new memberships page for \"([^"]+)\"/
      manage_new_section_memberships_path(find_section($1))
    when /the schedule rules page for \"([^"]+)\"/
      section_rules_path(find_section($1))
    when /the shifts management page for \"([^"]+)\"/
      section_shifts_path(find_section($1))
    when /the shift categories management page for \"([^"]+)\"/
      section_shift_tags_path(find_section($1))
    when /the administrators management page for \"([^"]+)\"/
      section_admins_path(find_section($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end

  private

  def find_section(title)
    Section.find_by_title(title)
  end

  def find_shift(title)
    Shift.find_by_title(title)
  end
end

World(NavigationHelpers)
