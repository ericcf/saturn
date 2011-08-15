When /^I view the reports page for a section$/ do
  Given %{a section}
  visit section_shift_totals_path(@section)
end
