Feature: add assignment requests
  So that I can notify the administrators of my intentions
  As a physician
  I should be able to request assignment days

Background:
  Given a shift "Call" in the "Nose" section
    And a physician "Cyrano deBergerac" in the "Nose" section

Scenario: add a new assignment request
   When I go to the new assignment request page for the "Nose" section
   Then I should see "New assignment request"
   When I select "Cyrano deBergerac" from "assignment_request_requester_id"
   When I select "Call" from "assignment_request_shift_id"
    And I fill in "assignment_request_start_date" with today's date
    And I fill in "assignment_request_end_date" with today's date
    And I press "Create Assignment request"
   Then I should be on the assignment requests page for the "Nose" section
    And I should see "Successfully submitted assignment request"
