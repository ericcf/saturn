Feature: add assignment requests
  So that I can notify the administrators of my intentions
  As an authenticated user
  I should be able to request assignment days

Background:
  Given a shift "Call" in the "Nose" section
    And I am an authenticated user associated with physician "Cyrano deBergerac"
    And a physician "Cyrano deBergerac" in the "Nose" section

Scenario: add a new assignment request
   When I go to the new assignment request page for the "Nose" section
   Then I should see "New assignment request"
   When I select "Call" from "assignment_request_shift_id"
    And I fill in "assignment_request_start_date" with today's date
    And I fill in "assignment_request_end_date" with today's date
    And I press "Create Assignment request"
   Then I should be on the assignment requests page for the "Nose" section
    And I should see "Successfully submitted assignment request"
