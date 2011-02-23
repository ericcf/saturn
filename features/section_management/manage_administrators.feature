Feature: Manage administrators
  So that I can control who can manage the section
  As a section administrator
  I should be able to manage administrators

Background:
  Given a section "Stadium"
    And I am an authenticated section administrator for "Stadium"
    And there is a user "alf@bar.com" with password "tasty_cat"

Scenario: View section administrators
  When I go to the administrators management page for "Stadium"
  Then I should see "Schedule Administrators"
