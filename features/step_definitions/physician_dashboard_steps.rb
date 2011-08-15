When /^I view a physician's dashboard$/ do
  Given %{There is a physician in a section with a published assignment}
  visit schedule_physician_path(@physician)
end

Then /^I should see the physician's published assignments$/ do
  page.should have_content(@shift.title)
end

When /^I access the iCalendar link$/ do
  click_on "Download or subscribe to iCalendar"
end
