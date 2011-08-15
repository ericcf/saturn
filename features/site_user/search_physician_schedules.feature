Feature: Search physician schedules
  So that I can find schedules quickly
  As a user
  I should be able to find this week's schedule by physician name

Scenario: Search for a physician by name
  When I search for a physician by name
  Then I should see the physician and published assignments in the results
