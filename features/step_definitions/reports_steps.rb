When /^I am viewing the reports page for "([^"]+)"$/ do |section_title|
  section = Section.find_by_title section_title
  @report_shift_totals_page = ReportPages::ShiftTotals.new(page,
    :section_id => section.id)
  @report_shift_totals_page.visit
end

When /^I select the following dates for the report:$/ do |table|
  dates = table.hashes.first
  @report_shift_totals_page.start_date = dates["Start"]
  @report_shift_totals_page.end_date = dates["End"]
end

When /^I press the "Get Report" button$/ do
  @report_shift_totals_page.get_report
end
