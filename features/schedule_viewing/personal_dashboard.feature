Feature: Personal dashboard
  In order to get an overview of her schedule status
  A user
  Can view her schedule and shift requests from her personal dashboard

Scenario: View a user's personal dashboard
  Given a section "The Highway" with a "Fellows" member "Harley David"
    And a weekly schedule for "The Highway" that begins on 2012-12-10 is published
    And a shift "Riding" in the "The Highway" section
    And "Harley David" is assigned to "Riding" in "The Highway" on 2012-12-10
   When I go to the personal dashboard for "Harley David" on 2012-12-10
   Then I should see "The Highway"
    And I should see "Riding"
