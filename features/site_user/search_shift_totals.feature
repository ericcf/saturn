Feature: Search shift totals for a section
  In order to determine physician distribution across shifts
  A user
  Should be able to summarize shift totals based on various parameters

Scenario: Use section shift totals search form
  Given a section "Nose" with a "Faculty" member "Cyrano D"
    And a weekly schedule for "Nose" that begins 2009-12-28 is published
    And a shift "Vacation" in the section "Nose"
    And "Cyrano D" is assigned to "Vacation" in "Nose" 2010-01-01
   When I go to the shift totals search page for "Nose"
    And I fill in "From" with "2010-01-01"
    And I fill in "To" with "2010-01-02"
    And press "Generate Report"
   Then I should be on the shift totals report page for "Nose"
    And I should see "Report for 1 January 2010 - 2 January 2010"
   When I follow "Vacation"
   Then I should be on the totals by day page for the "Vacation" shift in "Nose"
    And I should see "Daily Totals for Vacation, 1 January 2010 - 2 January 2010"
