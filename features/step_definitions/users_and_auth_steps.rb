module SiteHelper

  def default_email; "hank@saturn.net" end

  def default_password; "secret" end
end

World(SiteHelper)

Given /^a user "([^"]*)" with password "([^"]*)"$/ do |email, password|
  @user ||= User.create(:email => email, :password => password,
    :password_confirmation => password)
end

Given /^a user$/ do
  @user ||= User.create(:email => default_email,
                        :password => default_password,
                        :password_confirmation => default_password
                       )
end

Given /^the user is a section administrator$/ do
  @section.administrator_ids = @section.administrator_ids.concat([@user.id])
end

Given /^User "([^"]*)" is a site administrator$/ do |email|
  user = User.find_by_email(email)
  user.update_attribute(:admin, true)
end

Given /^I am an authenticated section administrator for the section$/ do
  Given %{a user}
    And %{the user is a section administrator}
    And %{I sign in as user "#{default_email}" with password "#{default_password}"}
end

Given /^I am an authenticated site administrator$/ do
  user_email = "admin@admin.com"
  password = "secret"
  Given %{a user "#{user_email}" with password "#{password}"}
    And %{User "#{user_email}" is a site administrator}
    And %{I sign in as user "#{user_email}" with password "#{password}"}
end

Given /^I sign in as user "([^"]*)" with password "([^"]*)"$/ do |email, password|
  Given %{I go to logout}
    And %{I go to login}
    And %{I fill in "user_email" with "#{email}"}
    And %{I fill in "user_password" with "#{password}"}
    And %{I press "Sign in"}
end

Given /^(?:|I am )an authenticated user$/ do
  Given %{a user "#{default_email}" with password "#{default_password}"}
    And %{I sign in as user "#{default_email}" with password "#{default_password}"}
end

Given /^I am an authenticated user associated with the physician$/ do
  Given %{a user "#{default_email}" with password "#{default_password}"}
  @user.physician = @physician
    And %{I sign in as user "#{default_email}" with password "#{default_password}"}
  @current_user = @user
end
