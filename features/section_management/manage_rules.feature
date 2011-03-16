Feature: Manage section schedule rules
  So that I can keep schedules balanced
  As a section administrator
  I should be able to manage schedule rules

Background:
  Given a section "Ear"
    And I am an authenticated section administrator for "Ear"
   When I go to the schedule rules page for "Ear"

Scenario: View section schedule rules
   Then I should see "Shift assignment rules"

Scenario: Add weekly shift limit rules
   When I follow "Edit Rules"
    And I select "0.5" from "Minimum"
    And I select "2.0" from "Maximum"
    And I press "Update Section"
   Then I should see "Successfully updated rules"
    And I should see "Maximum: 2.0"
    And I should see "Minimum: 0.5"

Scenario: Add daily shift limit rules
  Given a shift tag "General" in the "Ear" section
   When I follow "Edit Rules"
    And I select "2" from "General"
    And I press "Update Section"
   Then I should see "Successfully updated rules"
    And I should see "General: 2"
