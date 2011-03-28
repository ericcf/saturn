Feature: Manage administrators
  So that I can control who can manage the section
  As a section administrator
  I should be able to manage administrators

Scenario: Add a section administrator
   When I add a section administrator
   Then I should see "Successfully updated admins"

Scenario: Remove a section administrator
   When I remove a section administrator
   Then I should see "Successfully updated admins"
