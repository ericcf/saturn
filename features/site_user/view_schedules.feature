Feature: View schedules
  In order to determine what responsibilities a physician has
  A user
  Should be able to view schedules that display assignments

Scenario: View the published call schedule
  When I view the published call schedule
  Then I should be able to see the published call assignments

Scenario: View a published weekly section schedule by shift and physician, as html and xls
  Given there is a published schedule with a physician assigned to a shift
   Then I should be able to see the assignment in the published section schedule
   When I follow "Download as Excel"
   Then I should see an Excel file
   Then I should be able to see the assignment in the published section schedule by physician
   When I follow "Download as Excel"
   Then I should see an Excel file
