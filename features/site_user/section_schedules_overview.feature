Feature: Section schedules overview
  So that I can get a quick snapshot of weekly schedules
  As a user
  I should be able to view the status of all schedules for a section

Scenario: View schedule dates
  Given a section "Breast Imaging"
    And a weekly schedule for "Breast Imaging" that begins 2011-03-14
   When I go to the index page for "Breast Imaging"
   Then I should see "14 15 16 17 18 19 20"
