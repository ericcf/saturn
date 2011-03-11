Feature: Manage assignment requests
  So that I can keep the schedule up to date
  As a section administrator
  I should be able to manage physician assignment requests

Background:
  Given there is a user "harold@foo.com" with password "secret"
    And User "harold@foo.com" is a section administrator for the "MSK" section
    And a physician "Julia Child" in the "MSK" section
    And a shift "Kitchen" in the "MSK" section
    And I sign in as user "harold@foo.com" with password "secret"
   When I go to the new assignment request page for the "MSK" section
    And I select "Julia Child" from "assignment_request_requester_id"
    And I select "Kitchen" from "assignment_request_shift_id"
    And I fill in "assignment_request_start_date" with today's date
    And I press "Create Assignment request"

Scenario: Be notified of a new request
   Then I should have received an email at "harold@foo.com" with the subject "Saturn: Julia Child submitted a request"

Scenario: Approve a pending request
     And I go to the assignment requests page for the "MSK" section
    When I press "Approve"
    Then I should be on the assignment requests page for the "MSK" section
     And I should see "Successfully approved assignment request"
     And I should see "Approved"
     And "Julia Child" should be assigned to "Kitchen" in "MSK" on today's date
