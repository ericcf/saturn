When /^I add new weekly shift limit rules$/ do
  Given %{a section}
    And %{I am an authenticated section administrator for the section}
  visit section_rules_path(@section)
  click_on "Edit Rules"
  select "0.5", :from => "Minimum"
  select "2.0", :from => "Maximum"
  click_on "Update Section"
  rule = @section.weekly_shift_duration_rule
  assert_not_nil rule, "expected rule to have been created"
  assert_equal 0.5, rule.minimum, "expected rule minimum to be set"
  assert_equal 2.0, rule.maximum, "expected rule maximum to be set"
end

When /^I add new daily shift limit rules$/ do
  Given %{a section}
    And %{a shift tag}
  @section.shift_tags << @shift_tag
    And %{I am an authenticated section administrator for the section}
  visit section_rules_path(@section)
  click_on "Edit Rules"
  select "2", :from => @shift_tag.title
  click_on "Update Section"
  rules = @section.daily_shift_count_rules
  assert_equal 1, rules.count, "expected exactly one rule to have been created"
  assert_equal 2, rules.first.maximum, "expected rule maximum to be set"
end
