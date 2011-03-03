Feature: add vacation requests
  So that I can notify the administrators of my intentions
  As a physician
  I should be able to request vacation days

Background:
  Given a vacation shift "Vacation" in the "Nose" section
    And a physician "Cyrano deBergerac" in the "Nose" section

Scenario: add a new vacation request
   When I go to the new vacation request page for the "Nose" section
   Then I should see "New vacation request"
   When I select "Cyrano deBergerac" from "vacation_request_requester_id"
    And I fill in "vacation_request_start_date" with "2010-01-01"
    And I fill in "vacation_request_end_date" with "2010-01-02"
    And I press "Create Vacation request"
   Then I should be on the vacation requests page for the "Nose" section
    And I should see "Successfully submitted vacation request"
