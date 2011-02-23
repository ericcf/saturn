Feature: View meeting requests
  So that I can check the status of my own and others' meeting requests
  As a site visitor
  I want to be able to view all meeting requests

Scenario: View meeting requests
  Given a meeting request for "Dr. Evil" in the "Brain" section beginning 2010-01-01 and ending 2010-12-31
   When I go to the meeting requests page for the "Brain" section
   Then I should see "Meeting requests"
    And I should see "D. Evil"
