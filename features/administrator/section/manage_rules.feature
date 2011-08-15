Feature: Manage section schedule rules
  So that I can keep schedules balanced
  As a section administrator
  I should be able to manage schedule rules

Scenario: Add weekly shift limit rules
   When I add new weekly shift limit rules
   Then I should see "Successfully updated rules"

Scenario: Add daily shift limit rules
  Given I add new daily shift limit rules
   Then I should see "Successfully updated rules"
