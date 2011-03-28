When /^I prepare to manage shifts for the section "([^"]*)"$/ do |section_title|
  Given %{a section "#{section_title}"}
    And %{I am an authenticated section administrator for "#{section_title}"}
  section = Section.find_by_title(section_title)
  visit section_shifts_path(section)
end

When /^I add a shift to a section$/ do
  Given %{I prepare to manage shifts for the section "Chest"}
  click_link "Add Shift"
  fill_in "Title", :with => "Floater"
  click_on "Create Shift"
  section = Section.find_by_title("Chest")
  assert !section.shifts.find_by_title("Floater").nil?
end

When /^I add a category to a shift$/ do
  Given %{a shift "Meeting" in the section "Body and general"}
    And %{a shift tag "PM" in the section "Body and general"}
    And %{I prepare to manage shifts for the section "Body and general"}
  within("#current_shifts .shift:first") { click_link("edit") }
  within("#shift_shift_tags_input") { check("PM") }
  click_on "Update Shift"
  section = Section.find_by_title("Body and general")
  shift = section.shifts.find_by_title("Meeting")
  assert !shift.shift_tags.find_by_title("PM").nil?
end

When /^I modify a shift title from the shifts management page$/ do
  Given %{a shift "Meeting" in the section "Body and general"}
    And %{I prepare to manage shifts for the section "Body and general"}
  fill_in "section[shifts_attributes][0][title]", :with => "Meeting 1"
  click_on "Update Section"
  section = Section.find_by_title("Body and general")
  assert section.shifts.find_by_title("Meeting").nil?
  assert !section.shifts.find_by_title("Meeting 1").nil?
end

When /^I share a shift with another section$/ do
  Given %{a shift "Clinic" in the section "Neuroradiology"}
    And %{a section "Interventional radiology"}
    And %{I prepare to manage shifts for the section "Neuroradiology"}
  within("#current_shifts .shift:first") { click_link("edit") }
  within("#shift_sections_input") { check("Interventional radiology") }
  click_on "Update Shift"
  other_section = Section.find_by_title("Interventional radiology")
  assert !other_section.shifts.find_by_title("Clinic").nil?
end
