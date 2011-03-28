When /^I prepare to manage administrators for the section "([^"]*)"$/ do |section_title|
  Given %{a section "#{section_title}"}
    And %{I am an authenticated section administrator for "#{section_title}"}
  section = Section.find_by_title(section_title)
  visit section_admins_path(section)
end

When /^I add a section administrator(?: for section "([^"]+)")?$/ do |section_title|
  section_title ||= "Liver"
  Given %{there is a user "alf@bar.com" with password "tasty_cat"}
    And %{a section "#{section_title}"}
    And %{I prepare to manage administrators for the section "#{section_title}"}
  check "alf@bar.com"
  click_on "Update Section"
  section = Section.find_by_title(section_title)
  user = User.find_by_email("alf@bar.com")
  assert section.administrators.include?(user),
    "expected user to be administrator"
end

When /^I remove a section administrator$/ do
  Given %{I add a section administrator for section "Lungs"}
  section = Section.find_by_title("Lungs")
  user = section.administrators.last
  visit section_admins_path(section)
  uncheck user.email
  click_on "Update Section"
  assert !section.administrators.include?(user),
    "expected user not to be administrator"
end
