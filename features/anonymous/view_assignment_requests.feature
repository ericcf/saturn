Feature: View assignment requests
  So that I can check the status of my own and others' assignment requests
  As a site visitor
  I want to be able to view all assignment requests

Background:
  Given a section "Brain" with a "Faculty" member "Dr. Evil"
    And a shift "Surgery" in the section "Brain"
    And an assignment request for "Dr. Evil" on "Surgery" in the "Brain" section beginning today and ending tomorrow

Scenario: View assignment requests
  When I go to the assignment requests page for the "Brain" section
  Then I should see "Assignment requests"
   And I should see "D. Evil"
