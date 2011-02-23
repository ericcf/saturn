Feature: View schedules
  In order to determine what responsibilities a physician has
  A user
  Should be able to view schedules that display assignments

Scenario: View a published call schedule
  Given a section "The Diner" with a "Faculty" member "Jerry Seinfeld"
    And a shift "Lunch" in the "The Diner" section
    And "Lunch" in "The Diner" is tagged with "Call"
    And a weekly schedule for "The Diner" that begins 2010-11-22 is published
    And "Jerry Seinfeld" is assigned to "Lunch" in "The Diner" 2010-11-22
   When I go to the weekly call schedule page for the week beginning 2010-11-22
   Then I should see "Published Call Schedule"
    And I should see "Mon 11/22"
    And I should see "The Diner"
    And I should see "Lunch"
    And I should see "J. Seinfeld"

Scenario: View a published weekly section schedule by shift and physician, as html and xls
  Given a section "Disney World" with a "Faculty" member "Donald Duck"
    And a shift "Singing" in the "Disney World" section
    And a weekly schedule for "Disney World" that begins 2010-11-22 is published
    And "Donald Duck" is assigned to "Singing" in "Disney World" 2010-11-22
  When I go to the weekly section schedule page for "Disney World" on 2010-11-22
  Then I should see "Disney World"
   And I should see "Published Schedule"
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
