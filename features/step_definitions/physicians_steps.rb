When /^I prepare to manage physicians$/ do
  Given %{I am an authenticated site administrator}
  visit physicians_path
end

When /^I create an alias for a physician$/ do
  Given %{a physician "Lemony Snicket" in the section "Breast imaging"}
    And %{I prepare to manage physicians}
  within("tbody tr:first") { click_link "Edit Alias" }
  Then %{I should be on the new physician alias page for "Lemony Snicket"}
  fill_in "Short name", :with => "L. Snizzo"
  fill_in "Initials", :with => "LQS"
  click_on "Create Physician alias"
  physician = Physician.find_by_given_name_and_family_name("Lemony", "Snicket")
  assert physician.initials == "LQS"
  assert physician.short_name == "L. Snizzo"
end

When /^I update an alias for a physician$/ do
  Given %{a physician "Lemony Snicket" in the section "Interventional oncology"}
    And %{the alias "L. Snick", "LLS" for the physician "Lemony Snicket"}
    And %{I prepare to manage physicians}
  within("tbody tr:first") { click_link "Edit Alias" }
  Then %{I should be on the edit physician alias page for "Lemony Snicket"}
  fill_in "Short name", :with => "L. Snozzo"
  fill_in "Initials", :with => "LBS"
  click_on "Update Physician alias"
  physician = Physician.find_by_given_name_and_family_name("Lemony", "Snicket")
  assert physician.initials == "LBS"
  assert physician.short_name == "L. Snozzo"
end
