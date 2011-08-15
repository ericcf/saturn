Given /^I prepare to manage the weekly schedule for my section$/ do
  Given %{a section}
    And %{a physician}
    And %{the physician is a member of the section}
    And %{a shift}
    And %{the shift is associated with the section}
    And %{I am an authenticated section administrator for the section}
end

When /^I add a new assignment$/ do
  Given %{I prepare to manage the weekly schedule for my section}
  visit edit_section_weekly_schedules_path(@section)
  find(".shiftDay:first").click
  find(".physician-name:first").click
  assert Assignment.where(:physician_id => @physician.id, :shift_id => @shift.id), "expected assignment to have been created"
end

Then /^I should see the last saved date updated$/ do
  Then %{I should see the ajax result /last saved: \\d\\d\\d\\d/}
end

When /^I delete an existing assignment$/ do
  Given %{I prepare to manage the weekly schedule for my section}
  sleep 1
    And %{the physician is assigned to the shift}
  visit edit_section_weekly_schedules_path(@section)
  find(".assignment").click
  click_on "Delete assignment"
  sleep 1
  assert_equal 0, Assignment.count, "expected exactly zero assignments"
end

Then /^I should not see the assignment in the schedule$/ do
  within ".shiftDay" do
    page.should_not have_content(@physician.short_name)
  end
end

When /^I publish a new weekly schedule$/ do
  Given %{I prepare to manage the weekly schedule for my section}
  visit edit_section_weekly_schedules_path(@section)
  check "schedule-is-published"
  sleep 1
  assert_equal 1, @section.weekly_schedules.count,
    "expected exactly one weekly schedule"
end

When /^I publish an existing weekly schedule$/ do
  Given %{I prepare to manage the weekly schedule for my section}
  sleep 1
    And %{an unpublished weekly schedule in the section}
  visit edit_section_weekly_schedules_path(@section)
  check "schedule-is-published"
end

When /^I add a shift week note to a new weekly schedule$/ do
  Given %{I prepare to manage the weekly schedule for my section}
  visit edit_section_weekly_schedules_path(@section)
  When %{I update text field "shift-week-note" with "my note"}
end

Then /^I should see the text of the new shift week note$/ do
  assert_equal 1, ShiftWeekNote.count, "expected exactly one ShiftWeekNote"
  assert_equal ShiftWeekNote.first.text, page.find(".shift-week-note").value,
    "expected shift week note to appear on page"
end
