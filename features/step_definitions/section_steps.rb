Given /^a section "([^"]*)"$/ do |title|
  Section.create!(:title => title)
end

Given /^a section "([^"]*)" with a member "([^ ]+) ([^"]+)"$/ do |section_title, given_name, family_name|
  Given %{a section "#{section_title}"}
    And %{a physician "#{given_name} #{family_name}"}
  physician = Physician.find_by_given_name_and_family_name(given_name, family_name)
  Section.find_by_title(section_title).memberships.create(:physician_id => physician.id)
end

Given /^a shift "([^"]*)" in "([^"]*)"$/ do |shift_title, section_title|
  section = Section.find_by_title(section_title)
  Shift.create!(:section => section, :title => shift_title)
end

Given /^"([^"]*)" in "([^"]*)" is tagged with "([^"]*)"$/ do |shift_title, section_title, shift_tag_title|
  section = Section.find_by_title(section_title)
  tag = ShiftTag.create!(:section => section, :title => shift_tag_title)
  tag.shifts << section.shifts.find_by_title(shift_title)
end

Given /^a weekly schedule for "([^"]*)" that begins on (\d{4}-\d{2}-\d{2})( is published)?$/ do |section_title, date, is_published|
  section = Section.find_by_title(section_title)
  to_publish = is_published.nil? ? 0 : 1
  section.weekly_schedules.create!(:date => Date.parse(date), :publish => to_publish)
end

Given /^"([^ ]+) ([^"]+)" is assigned to "([^"]*)" in "([^"]*)" on (\d{4}-\d{2}-\d{2})$/ do |given_name, family_name, shift_title, section_title, date|
  physician = Physician.find_by_given_name_and_family_name(given_name, family_name)
  section = Section.find_by_title(section_title)
  shift = section.shifts.find_by_title(shift_title)
  assignment_date = Date.parse(date)
  schedule = section.weekly_schedules.include_date(assignment_date).first
  schedule.assignments.create(:physician_id => physician.id, :shift => shift, :date => assignment_date)
end

Given /^User "([^"]*)" is a section administrator for "([^"]*)"$/ do |user_email, section_title|
  user = Deadbolt::User.find_by_email(user_email)
  section = Section.find_by_title(section_title)
  section.administrator_ids = section.administrator_ids.concat([user.id])
end

Given /^I am an authenticated section administrator for "([^"]*)"$/ do |section_title|
  user_email = "joe@joe.com"
  password = "secret"
  Given %{there is a user "#{user_email}" with password "#{password}"}
  And %{User "#{user_email}" is a section administrator for "#{section_title}"}
  And %{I sign in as user "#{user_email}" with password "#{password}"}
end

Then /^I should be able to view the edit weekly schedule page for "([^"]*)"$/ do |section_title|
  Given %{I go to edit weekly schedule page for "#{section_title}"}
  Then %{I should see "Editing Week of "}
end
