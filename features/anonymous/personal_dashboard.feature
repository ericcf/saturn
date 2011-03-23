Feature: Personal dashboard
  In order to get an overview of her schedule status
  A user
  Can view her schedule and shift requests from her personal dashboard

Background:
  Given a section "The Highway" with a "Fellows" member "Harley David"
    And a weekly schedule for "The Highway" that begins 2012-12-10 is published
    And a shift "Riding" in the section "The Highway"
    And "Harley David" is assigned to "Riding" in "The Highway" 2012-12-10

Scenario: View a user's personal dashboard
   When I go to the personal dashboard for "Harley David" on 2012-12-10
   Then I should see "The Highway"
    And I should see "Riding"

Scenario: Download a user's calendar as an ics file
   When I go to the personal dashboard for "Harley David" on 2012-12-10
    And I follow "Download or subscribe to iCalendar"
   Then I should see an iCal file
