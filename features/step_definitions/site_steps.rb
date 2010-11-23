Given /^there is a user "([^"]*)" with password "([^"]*)"$/ do |email, password|
  Deadbolt::User.create!(:email => email, :password => password,
    :password_confirmation => password)
end

Given /^User "([^"]*)" is a site administrator$/ do |email|
  user = Deadbolt::User.find_by_email(email)
  user.update_attribute(:admin, true)
end

Given /^I sign in as user "([^"]*)" with password "([^"]*)"$/ do |email, password|
  Given %{I go to logout}
    And %{I go to login}
    And %{I fill in "user_email" with "#{email}"}
    And %{I fill in "user_password" with "#{password}"}
    And %{I press "Sign in"}
end

Given /^I am an authenticated site administrator$/ do
  user_email = "admin@admin.com"
  password = "secret"
  Given %{there is a user "#{user_email}" with password "#{password}"}
    And %{User "#{user_email}" is a site administrator}
    And %{I sign in as user "#{user_email}" with password "#{password}"}
end

Given /^a physician "([^ ]+) ([^"]+)"$/ do |given_name, family_name|
  physician = Physician.new
  physician.given_name = given_name
  physician.family_name = family_name
  physician.save!
end

Given /^a physician "([^ ]+) ([^"]+)", member of the "([^"]*)" section$/ do |given_name, family_name, section_title|
  Given %{a physician "#{given_name} #{family_name}"}
    And %{a section "#{section_title}"}
  physician = Physician.find_by_given_name_and_family_name(given_name, family_name)
  section = Section.find_by_title(section_title)
  SectionMembership.create!(:physician_id => physician.id, :section => section)
end

Given /^the alias "([^"]*)", "([^"]*)" for the physician "([^ ]+) ([^"]+)"$/ do |short_name, initials, given_name, family_name|
  physician = Physician.find_by_given_name_and_family_name(given_name, family_name)
  PhysicianAlias.create!(:physician_id => physician.id, :initials => initials,
    :short_name => short_name)
end
