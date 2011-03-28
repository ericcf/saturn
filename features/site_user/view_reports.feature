Feature: View reports
  In order to assess physician distribution across shifts
  A user
  Should be able to view reports on published schedules

Scenario: View default section report
  Given a section "Brain"
   When I go to the reports page for "Brain"
   Then I should see "Totals from Published Weekly Schedules"
