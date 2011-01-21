Feature: search shift totals for a section
  In order to determine physician distribution across shifts
  A user
  Should be able to summarize shift totals based on various parameters

@wip
Scenario: Use section shift totals search form
  Given a section "Nose"
    And a shift "Vacation" in the "Nose" section
   When I go to the shift totals search page for "Nose"
    And I fill in "shift_totals_report_start_date" with "2010-01-01"
    And I fill in "shift_totals_report_end_date" with "2010-01-02"
    And press "Generate Report"
   Then I should be on the shift totals report page for "Nose"
    And I should see "Report for 1 January 2010 - 2 January 2010"
   When I follow "Vacation" within "th a"
   Then I should be on the totals by day page for the "Vacation" shift in "Nose"
    And I should see "Daily Totals for Vacation, 1 January 2010 - 2 January 2010"
