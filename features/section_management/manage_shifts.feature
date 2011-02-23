Feature: Manage shifts
  So that I can organize physician assignments
  As a section administrator
  I should be able to manage shifts

Background:
  Given a section "Throat"
    And I am an authenticated section administrator for "Throat"
    And a shift "Meeting" in the "Throat" section

Scenario: View shift management page
  When I go to the shifts management page for "Throat"
  Then I should see "Manage Shifts"
