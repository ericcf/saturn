When /^I prepare to manage sections$/ do
  Given %{I am an authenticated site administrator}
  visit sections_path
end

When /^I create a new section$/ do
  Given %{I prepare to manage sections}
  click_on "Add New Section"
  fill_in "Title", :with => "Thorax"
  click_on "Create Section"
  assert !Section.find_by_title("Thorax").nil?
end

When /^I update an existing section$/ do
  Given %{a section "Thumb"}
    And %{I prepare to manage sections}
  within(".section:first") { click_on "Edit" }
  Then %{I should be on the edit section page for "Thumb"}
  fill_in "Title", :with => "Ring finger"
  click_on "Update Section"
  assert Section.find_by_title("Thumb").nil?
  assert !Section.find_by_title("Ring finger").nil?
end
