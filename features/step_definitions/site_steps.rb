module SiteHelper

  def default_email; "hank@saturn.net" end

  def default_password; "secret" end
end

World(SiteHelper)

Given /^there is a user "([^"]*)" with password "([^"]*)"$/ do |email, password|
  @user = User.create(:email => email, :password => password,
    :password_confirmation => password)
end

Given /^User "([^"]*)" is a site administrator$/ do |email|
  user = User.find_by_email(email)
  user.update_attribute(:admin, true)
end

Given /^I sign in as user "([^"]*)" with password "([^"]*)"$/ do |email, password|
  Given %{I go to logout}
    And %{I go to login}
    And %{I fill in "user_email" with "#{email}"}
    And %{I fill in "user_password" with "#{password}"}
    And %{I press "Sign in"}
end

Given /^I am an authenticated user associated with physician "([^ ]+) ([^"]+)"$/ do |given_name, family_name|
  Given %{there is a user "#{default_email}" with password "#{default_password}"}
    And %{a physician "#{given_name} #{family_name}"}
  @user.update_attribute(:physician_id, @physician.id)
    And %{I sign in as user "#{default_email}" with password "#{default_password}"}
end

Given /^I am an authenticated site administrator$/ do
  user_email = "admin@admin.com"
  password = "secret"
  Given %{there is a user "#{user_email}" with password "#{password}"}
    And %{User "#{user_email}" is a site administrator}
    And %{I sign in as user "#{user_email}" with password "#{password}"}
end

Given /^a physician "([^ ]+) ([^"]+)"$/ do |given_name, family_name|
  unless @physician
    @physician = Physician.new
    @physician.given_name = given_name
    @physician.family_name = family_name
    @physician.save!
    @physician.emails << RadDirectory::Email.new(:value => default_email, :category => "work")
  end
end

Given /^a physician "([^ ]+) ([^"]+)" in the "([^"]*)" section$/ do |given_name, family_name, section_title|
  Given %{a physician "#{given_name} #{family_name}"}
    And %{a section "#{section_title}"}
  section = Section.find_by_title(section_title)
  SectionMembership.create!(:physician_id => @physician.id, :section => section)
end

Given /^the alias "([^"]*)", "([^"]*)" for the physician "([^ ]+) ([^"]+)"$/ do |short_name, initials, given_name, family_name|
  Given %{a physician "#{given_name} #{family_name}"}
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
