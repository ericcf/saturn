When /^I prepare to manage administrators for the section$/ do
  Given %{I am an authenticated section administrator for the section}
  visit section_admins_path(@section)
end

When /^I add a section administrator$/ do
  section_title ||= "Liver"
  @new_user = User.create(:email => "foo@bar.com",
                          :password => "my secret",
                          :password_confirmation => "my secret")
    And %{a section}
    And %{I prepare to manage administrators for the section}
  check @new_user.email
  click_on "Update Section"
  # reload to get fresh associations
  @section = Section.first
  assert @section.administrators.include?(@new_user),
    "expected user to be administrator"
end

When /^I remove a section administrator$/ do
  Given %{I add a section administrator}
  visit section_admins_path(@section)
  uncheck @new_user.email
  click_on "Update Section"
  assert !@section.administrators.include?(@new_user),
    "expected user not to be administrator"
end
