Feature: View vacation requests
  So that I can check the status of my own and others' vacation requests
  As a site visitor
  I want to be able to view all vacation requests

Scenario: View vacation requests
  Given a vacation request for "Dr. Evil" in the "Brain" section beginning 2010-01-01 and ending 2010-12-31
   When I go to the vacation requests page for the "Brain" section
   Then I should see "Vacation requests"
    And I should see "D. Evil"
