Feature: Search shift totals for a section
  In order to determine physician distribution across shifts
  A user
  Should be able to summarize shift totals based on various parameters

Scenario: Use section shift totals search form
  When I search the shift totals for a section
  Then I should see the shift totals report
  When I view the totals by day for a shift
  Then I should see the daily shift totals report
