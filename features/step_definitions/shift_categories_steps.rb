When /^I add a new shift category$/ do
  Given %{a section}
    And %{I am an authenticated section administrator for the section}
  visit section_shift_tags_path(@section)
  click_on "Add Category"
  fill_in "Title", :with => "Non-clinical"
  click_on "Create Shift tag"
  shift_tags = @section.shift_tags
  assert_equal 1, shift_tags.count, "expected to add exactly one shift tag"
  assert_equal "Non-clinical", shift_tags.first.title,
    "expected shift tag title to be set"
end

When /^I update an existing shift category title from the management page$/ do
  Given %{a section}
    And %{a shift tag}
    And %{I am an authenticated section administrator for the section}
  @section.shift_tags << @shift_tag
  visit section_shift_tags_path(@section)
  fill_in "section[shift_tags_attributes][0][title]",
          :with => @shift_tag.title + " Foo!"
  click_on "Update Section"
  shift_tags = @section.shift_tags
  assert_equal 1, shift_tags.count, "expected to find exactly one shift tag"
  assert_equal @shift_tag.title + " Foo!", shift_tags.first.title,
    "expected shift tag title to be updated"
end
