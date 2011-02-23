Feature: add meeting requests
  So that I can notify the administrators of my intentions
  As a physician
  I should be able to request meeting days

Background:
  Given a shift "Meeting" in the "Nose" section
    And a physician "Cyrano deBergerac" in the "Nose" section

Scenario: add a new meeting request
   When I go to the new meeting request page for the "Nose" section
   Then I should see "New meeting request"
   When I select "Cyrano deBergerac" from "meeting_request_requester_id"
    And I fill in "meeting_request_start_date" with "2010-01-01"
    And I fill in "meeting_request_end_date" with "2010-01-02"
    And I press "Create Meeting request"
   Then I should be on the meeting requests page for the "Nose" section
    And I should see "Successfully submitted meeting request"
