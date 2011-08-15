Feature: View reports
  In order to assess physician distribution across shifts
  A user
  Should be able to view reports on published schedules

Scenario: View default section report
  When I view the reports page for a section
  Then I should see "Totals from Published Weekly Schedules"
