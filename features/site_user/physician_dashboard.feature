Feature: Physician dashboard
  In order to get an overview of her schedule status
  A user
  Can view her schedule and shift requests from her physician dashboard

Scenario: View a physician's dashboard
   When I view a physician's dashboard
   Then I should see the physician's published assignments

Scenario: Download a user's calendar as an ics file
   When I view a physician's dashboard
   When I access the iCalendar link
   Then I should see an iCal file
