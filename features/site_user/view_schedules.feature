Feature: View schedules
  In order to determine what responsibilities a physician has
  A user
  Should be able to view schedules that display assignments

Scenario: View a published call schedule
  Given there is a published schedule with a physician assigned to a call shift
   Then I should be able to see the assignment in the published call schedule

Scenario: View a published weekly section schedule by shift and physician, as html and xls
  Given a section "Disney World" with a "Faculty" member "Donald Duck"
    And a shift "Singing" in the section "Disney World"
    And a weekly schedule for "Disney World" that begins 2010-11-22 is published
    And "Donald Duck" is assigned to "Singing" in "Disney World" 2010-11-22
   When I go to the weekly section schedule page for "Disney World" on 2010-11-22
   Then I should see "Disney World"
    And I should see "Published schedule"
    And I should see "Singing"
    And I should see "D. Duck"
   When I follow "Download as Excel"
   Then I should see an Excel file
   When I go to the weekly section schedule page for "Disney World" on 2010-11-22
    And I follow "View by Physician"
   Then I should see "View by Shift"
    And I should see "D. Duck"
    And I should see "Singing"
   When I follow "Download as Excel"
   Then I should see an Excel file
