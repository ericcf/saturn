Feature: Manage section schedule rules
  So that I can keep schedules balanced
  As a section administrator
  I should be able to manage schedule rules

Background:
  Given a section "Ear"

Scenario: View section schedule rules
  When I go to the schedule rules page for "Ear"
  Then I should see "Shift assignment rules"
