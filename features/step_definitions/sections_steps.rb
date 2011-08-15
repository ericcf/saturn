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
  Given %{a section}
  original_title = @section.title
    And %{I prepare to manage sections}
  within(".section:first") { click_on "Edit" }
  fill_in "Title", :with => "#{original_title} Too"
  click_on "Update Section"
  assert_nil Section.find_by_title(original_title)
    "expected not to find section by original title"
  assert_not_nil Section.find_by_title(original_title + " Too"),
    "expected to find section by new title"
end
