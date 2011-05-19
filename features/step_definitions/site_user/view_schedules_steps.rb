Given /^there is a published schedule with a physician assigned to a call shift$/ do
  section = Section.create! :title => "General"
  physician = Physician.new
  physician.given_name = "Barney"
  physician.family_name = "Flarney"
  physician.save!
  faculty = RadDirectory::Group.find_or_create_by_title "Faculty"
  faculty.members << physician
  section.memberships.create :physician_id => physician.id
  shift = section.call_shifts.create :title => "Alpha Call"
  section.weekly_schedules.create! :date => Date.today.at_beginning_of_week,
    :is_published => true
  Assignment.create! :physician_id => physician.id, :shift_id => shift.id,
    :date => Date.today
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
