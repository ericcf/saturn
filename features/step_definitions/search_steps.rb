When /^I search for a physician by name$/ do
  Given %{There is a physician in a section with a published assignment}
  visit search_physicians_path
  fill_in "query", :with => @physician.family_name
  click_on "Search Physicians"
end

Then /^I should see the physician and published assignments in the results$/ do
  page.should have_content(@physician.full_name)
  page.should have_content(@shift.title)
end
