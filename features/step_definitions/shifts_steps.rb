When /^I prepare to manage shifts for the section$/ do
  Given %{a section}
    And %{I am an authenticated section administrator for the section}
  visit section_shifts_path(@section)
end

When /^I add a shift to a section$/ do
  Given %{I prepare to manage shifts for the section}
  click_link "Add Shift"
  fill_in "Title", :with => "Floater"
  click_on "Create Shift"
  assert !@section.shifts.find_by_title("Floater").nil?
end

When /^I add a category to a shift$/ do
  Given %{a section}
    And %{a shift}
    And %{the shift is associated with the section}
    And %{a shift tag}
  @section.shift_tags << @shift_tag
    And %{I prepare to manage shifts for the section}
  within("#current_shifts .shift:first") { click_link("edit") }
  within("#shift_shift_tags_input") { check(@shift_tag.title) }
  click_on "Update Shift"
  assert !@shift.shift_tags.find_by_title(@shift_tag.title).nil?
end

When /^I modify a shift title from the shifts management page$/ do
  Given %{a section}
    And %{a shift}
    And %{the shift is associated with the section}
    And %{I prepare to manage shifts for the section}
  fill_in "section[shifts_attributes][0][title]", :with => @shift.title + " 1"
  click_on "Update Section"
  sleep 1
  assert @section.shifts.find_by_title(@shift.title).nil?,
    "shift with old title should not exist"
  assert !@section.shifts.find_by_title(@shift.title + " 1").nil?,
    "shift with new title should exist"
end

When /^I share a shift with another section$/ do
  Given %{a section}
    And %{a shift}
    And %{the shift is associated with the section}
    And %{I prepare to manage shifts for the section}
    And %{a second section}
  within("#current_shifts .shift:first") { click_link("edit") }
  within("#shift_sections_input") { check(@section_2.title) }
  click_on "Update Shift"
  assert !@section_2.shifts.find_by_title(@shift.title).nil?,
    "expected the shift to be shared with the second section"
end

When /^I retire a shift$/ do
  Given %{a section}
    And %{a shift}
    And %{the shift is associated with the section}
    And %{I prepare to manage shifts for the section}
  @shifts_page = ShiftsPage.new(page, :section_id => @section.id)
  @shifts_page.visit
  @shifts_page.retire_shift 0
  @shifts_page.update
end

Then /^I should see the shift in the list of retired shifts$/ do
  @shifts_page.retired_shifts.should include(@shift.title)
end
