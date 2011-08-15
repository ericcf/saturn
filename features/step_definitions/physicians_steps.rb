When /^I prepare to manage physicians$/ do
  Given %{I am an authenticated site administrator}
  visit physicians_path
end

When /^I create an alias for a physician$/ do
  Given %{a section}
    And %{a physician}
    And %{the physician is a member of the section}
    And %{I prepare to manage physicians}
  physicians = Physician.all
  assert_equal 1, physicians.count
  within("tbody tr:first") { click_link "Edit Alias" }
  assert_equal new_physician_physician_alias_path(physicians.first),
    URI.parse(current_url).path
  fill_in "Short name", :with => "L. Snizzo"
  fill_in "Initials", :with => "LQS"
  click_on "Create Physician alias"
  assert_equal "LQS", physicians.first.initials
    "expected initials to have been updated"
  assert physicians.first.short_name == "L. Snizzo"
end

When /^I update an alias for a physician$/ do
  Given %{a section}
    And %{a physician}
    And %{the physician is a member of the section}
    And %{an alias for the physician}
    And %{I prepare to manage physicians}
  physicians = Physician.all
  assert_equal 1, physicians.count
  within("tbody tr:first") { click_link "Edit Alias" }
  assert_equal edit_physician_physician_alias_path(physicians.first),
    URI.parse(current_url).path
  fill_in "Short name", :with => "L. Snozzo"
  fill_in "Initials", :with => "LBS"
  click_on "Update Physician alias"
  assert physicians.first.initials == "LBS"
  assert physicians.first.short_name == "L. Snozzo"
end
