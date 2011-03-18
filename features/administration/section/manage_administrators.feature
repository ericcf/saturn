Feature: Manage administrators
  So that I can control who can manage the section
  As a section administrator
  I should be able to manage administrators

Background:
  Given a section "Stadium"
    And I am an authenticated section administrator for "Stadium"
    And there is a user "alf@bar.com" with password "tasty_cat"
    And I go to the administrators management page for "Stadium"

Scenario: View section administrators
   Then I should see "Schedule Administrators"

Scenario: Add and remove section administrators
   When I check "alf@bar.com"
    And I press "Update Section"
   Then I should see "Successfully updated admins"
    And the "alf@bar.com" checkbox should be checked
   When I uncheck "alf@bar.com"
    And I press "Update Section"
   Then I should see "Successfully updated admins"
    And the "alf@bar.com" checkbox should not be checked
