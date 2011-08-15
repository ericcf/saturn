When /^I prepare to manage members for the section$/ do
  Given %{I am an authenticated section administrator for the section}
  visit section_memberships_path(@section)
end

When /^I add a new member to a section$/ do
  Given %{a section}
    And %{a physician}
    And %{I prepare to manage members for the section}
  click_on "Add Members"
  within("form") { check(@physician.full_name) }
  click_on "Update Section"
  # refresh stale associations
  @section = Section.first
  assert @section.members.include?(@physician),
    "expected section members not to include physician"
end

Then /^there should be a user associated with the new section member$/ do
  assert Section.count == 1
  section = Section.first
  assert section.members.count == 1
  assert !User.where(:physician_id => section.members.first.id).blank?
end

When /^I remove an existing member from a section$/ do
  Given %{a section}
    And %{a physician}
    And %{the physician is a member of the section}
    And %{I prepare to manage members for the section}
  click_on "Remove Members"
  check @physician.full_name
  click_on "Update Section"
  # refresh stale associations
  @section = Section.first
  assert !@section.members.include?(@physician),
    "expected section members not to include physician"
end
