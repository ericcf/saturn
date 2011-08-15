Given /^a physician "([^ ]+) ([^"]+)" in the section "([^"]*)"$/ do |given_name, family_name, section_title|
  Given %{a physician}
    And %{a section "#{section_title}"}
  section = Section.find_by_title(section_title)
  SectionMembership.create!(:physician_id => @physician.id, :section => section)
end

Given /^the alias "([^"]*)", "([^"]*)" for the physician "([^ ]+) ([^"]+)"$/ do |short_name, initials, given_name, family_name|
  Given %{a physician}
  PhysicianAlias.create!(:physician_id => @physician.id, :initials => initials,
    :short_name => short_name)
end

Then /^there should be a user that belongs to "([^ ]+) ([^"]+)"$/ do |given_name, family_name|
  Given %{a physician "#{given_name} #{family_name}"}
  assert User.find_by_physician_id(@physician.id).present?, "there should be a user that belongs to \"#{given_name} #{family_name}\""
end

Then /^"([^"]+)" should have received an email with the subject "([^"]+)"$/ do |to_address, subject|
  assert !ActionMailer::Base.deliveries.empty?, "no emails were sent"
  email = ActionMailer::Base.deliveries.last
  assert email.to.include?(to_address), "the 'to' address didn't match #{to_address}"
  assert_equal subject, email.subject, "the subject didn't match #{subject}"
end

Then /^physician "([^ ]+) ([^"]+)" should have received an email with the subject "([^"]+)"$/ do |given_name, family_name, subject|
  physician = Physician.find_by_given_name_and_family_name(given_name, family_name)
  Then %{"#{physician.work_email}" should have received an email with the subject "#{subject}"}
end
