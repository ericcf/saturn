When /^I prepare to manage members for the section "([^"]+)"$/ do |section_title|
  Given %{I am an authenticated section administrator for "#{section_title}"}
  section = Section.find_by_title(section_title)
  visit section_memberships_path(section)
end

When /^I add a new member to a section$/ do
  Given %{a "Faculty" member "Spud McKenzie"}
    And %{I prepare to manage members for the section "General"}
  click_on "Add Members"
  within("form") { check("Spud McKenzie") }
  click_on "Update Section"
  section = Section.find_by_title("General")
  physician = Physician.find_by_given_name_and_family_name("Spud", "McKenzie")
  assert section.members.include?(physician)
end

Then /^there should be a user associated with the new section member$/ do
  assert Section.count == 1
  section = Section.first
  assert section.members.count == 1
  assert !User.where(:physician_id => section.members.first.id).blank?
end

When /^I remove an existing member from a section$/ do
  Given %{a section "Nuclear medicine" with a "Fellows" member "Barry Bonds"}
    And %{I prepare to manage members for the section "Nuclear medicine"}
  click_on "Remove Members"
  check "Barry Bonds"
  click_on "Update Section"
  section = Section.find_by_title("Nuclear medicine")
  physician = Physician.find_by_given_name_and_family_name("Barry", "Bonds")
  assert !section.members.include?(physician)
end
