When /^I view the published call schedule$/ do
  Given %{There is a physician in a section with a published call assignment}
  visit weekly_call_schedule_path
end

Then /^I should be able to see the published call assignments$/ do
  page.should have_content(@call_shift.title)
end

Given /^there is a published schedule with a physician assigned to a shift$/ do
  Given %{a section}
    And %{a physician}
    And %{the physician is a member of the section}
    And %{a shift}
    And %{the shift is associated with the section}
  @section.weekly_schedules.create!(:date => Date.today.at_beginning_of_week,
                                    :is_published => true
                                   )
  Assignment.create!(:physician_id => @physician.id,
                     :shift_id => @shift.id,
                     :date => Date.today
                    )
end

Then /^(?:I )should be able to see the assignment in the published call schedule$/ do
  schedules = WeeklySchedule.where :is_published => true
  assert_equal schedules.count, 1,
    "expected to find exactly 1 published schedule"
  physicians = Physician.all
  assert_equal physicians.count, 1,
    "expected to find exactly 1 physician"
  visit weekly_call_schedule_path
  assert page.has_content?(physicians.first.short_name),
    "expected to see physician assigned to call shift in published schedule"
end

Then /^I should be able to see the assignment in the published section schedule$/ do
  visit weekly_section_schedule_path(@section)
  within(".schedule-wrapper table.schedule tr") do
    within("th span") { page.should have_content(@shift.title) }
    within("td span") { page.should have_content(@physician.short_name) }
  end
end

Then /^I should be able to see the assignment in the published section schedule by physician$/ do
  visit weekly_section_schedule_path(@section, :view_mode => 2)
  within(".schedule-wrapper table.schedule tr") do
    within("th a") { page.should have_content(@physician.short_name) }
    within("td span") { page.should have_content(@shift.title) }
  end
end
