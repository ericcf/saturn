module SectionHelper

  def find_or_create_physician(given_name, family_name)
    Physician.find_by_given_name_and_family_name(given_name, family_name) || (
      physician = Physician.new
      physician.given_name = given_name; physician.family_name = family_name
      physician.save!
      physician
    )
  end

  def find_or_create_section(section_title)
    Section.find_or_create_by_title(section_title)
  end

  def parse_date(date)
    case date
    when "Monday"
      Date.today.at_beginning_of_week
    when "today"
      Date.today
    else
      Date.parse date
    end
  end
end

World(SectionHelper)

Given /^a shift "([^"]*)" in the section "([^"]*)"$/ do |shift_title, section_title|
  section = find_or_create_section(section_title)
  section.shifts.create(:title => shift_title)
end

Given /^a call shift "([^"]*)" in the section "([^"]*)"$/ do |shift_title, section_title|
  section = find_or_create_section(section_title)
  section.call_shifts.create(:title => shift_title)
end

Given /^a vacation shift "([^"]*)" in the section "([^"]*)"$/ do |shift_title, section_title|
  section = find_or_create_section(section_title)
  section.vacation_shifts.create(:title => shift_title)
end

Given /^a meeting shift "([^"]*)" in the "([^"]*)" section$/ do |shift_title, section_title|
  section = find_or_create_section(section_title)
  section.meeting_shifts.create(:title => shift_title)
end

Given /^an assignment request for "([^ ]+) ([^"]+)" on "([^"]*)" in the "([^"]*)" section beginning today and ending tomorrow/ do |given_name, family_name, shift_title, section_title|
  physician = find_or_create_physician(given_name, family_name)
  section = find_or_create_section(section_title)
  shift = section.shifts.create(:title => shift_title)
  AssignmentRequest.create!(
    :requester_id => physician.id,
    :shift_id => shift.id,
    :start_date => Date.today,
    :end_date => Date.tomorrow,
    :shift => section.shifts.create(:title => "AM Conference")
  )
end

Given /^a shift tag "([^"]*)" in the section "([^"]*)"$/ do |shift_tag_title, section_title|
  section = find_or_create_section(section_title)
  section.shift_tags.create(:title => shift_tag_title)
end

Given /^"([^"]*)" in "([^"]*)" is tagged with "([^"]*)"$/ do |shift_title, section_title, shift_tag_title|
  section = Section.find_by_title(section_title)
  tag = ShiftTag.create!(:section => section, :title => shift_tag_title)
  tag.shifts << section.shifts.find_by_title(shift_title)
end

Given /^a weekly schedule for "([^"]*)" that begins ((?:\d{4}-\d{2}-\d{2})|(?:[^ ]+))( is published)?$/ do |section_title, date, is_published|
  section = Section.find_by_title(section_title)
  section.weekly_schedules.create!(:date => parse_date(date), :is_published => is_published ? true : false)
end

Given /^"([^ ]+) ([^"]+)" is assigned to "([^"]*)" in "([^"]*)" ((?:\d{4}-\d{2}-\d{2})|(?:[^ ]+))$/ do |given_name, family_name, shift_title, section_title, date|
  physician = find_or_create_physician(given_name, family_name)
  section = Section.find_by_title(section_title)
  shift = section.shifts.find_by_title(shift_title)
  assignment_date = parse_date(date)
  schedule = section.weekly_schedules.include_dates([assignment_date]).first
  Assignment.create(:physician_id => physician.id, :shift => shift, :date => assignment_date)
end

Then /^I should be able to view the edit weekly schedule page for "([^"]*)"$/ do |section_title|
  Given %{I go to the edit weekly schedule page for "#{section_title}"}
  Then %{I should see "Editing the week of "}
end

Then /^"([^ ]+) ([^"]+)" should be assigned to "([^"]+)" in "([^"]+)"(?: on (today)'s date)?$/ do |given_name, family_name, shift_title, section_title, today|
  physician = find_or_create_physician(given_name, family_name)
  section = find_or_create_section(section_title)
  shift = section.shifts.find_by_title(shift_title)
  conditions = { :physician_id => physician.id, :shift_id => shift.id }
  conditions[:date] = Date.today unless today.nil?
  assignments = section.assignments.where(conditions)
  assert !assignments.blank?, "requested assignment not found"
end

When /^I view the yearly schedule for a section$/ do
  Given %{a section}
    And %{an unpublished weekly schedule in the section}
  visit section_path(@section)
end

Then /^I should see the schedule dates$/ do
  @weekly_schedule.dates.each do |date|
    page.should have_content(date.day.to_s)
  end
end
