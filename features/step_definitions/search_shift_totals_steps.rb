When /^I search the shift totals for a section$/ do
  Given %{There is a physician in a section with a published assignment}
  visit search_shift_totals_section_reports_path(@section)
  fill_in "From", :with => @weekly_schedule.date.to_s(:db)
  fill_in "To", :with => @weekly_schedule.dates.last.to_s(:db)
  click_on "Generate Report"
end

Then /^I should see the shift totals report$/ do
  page.should have_content("Report for #{@weekly_schedule.date.strftime("%e %B %Y")} - #{@weekly_schedule.dates.last.strftime("%e %B %Y")}".gsub(/ +/, " "))
end

When /^I view the totals by day for a shift$/ do
  click_on @shift.title
end

Then /^I should see the daily shift totals report$/ do
  page.should have_content("Daily Totals for #{@shift.title}, #{@weekly_schedule.date.strftime("%e %B %Y")} - #{@weekly_schedule.dates.last.strftime("%e %B %Y")}".gsub(/ +/, " "))
end
