Feature: Manage shift categories
  So that I can organize physician assignments
  As a section administrator
  I should be able to manage shift categories

Background:
  Given a section "Throat"
    And I am an authenticated section administrator for "Throat"
    And a shift tag "AM" in the "Throat" section

Scenario: View shift categories management page
  When I go to the shift categories management page for "Throat"
  Then I should see "Manage Shift Categories"
