Feature: Manage vacation requests
  So that I can keep the schedule up to date
  As a section administrator
  I should be able to manage physician vacation requests

Background:
  Given there is a user "harold@foo.com" with password "secret"
    And User "harold@foo.com" is a section administrator for the "MSK" section
    And a physician "Julia Child" in the "MSK" section
    And a vacation shift "Vacation" in the "MSK" section
   When I go to the new vacation request page for the "MSK" section
    And I select "Julia Child" from "vacation_request_requester_id"
    And I fill in "vacation_request_start_date" with "2010-01-01"
    And I press "Create Vacation request"

Scenario: Be notified of a new request
   Then I should have received an email at "harold@foo.com" with the subject "Saturn: New Vacation Request"

Scenario: Approve a pending request
   Given I sign in as user "harold@foo.com" with password "secret"
     And I go to the vacation requests page for the "MSK" section
    When I press "Approve"
    Then I should be on the vacation requests page for the "MSK" section
     And I should see "Successfully approved vacation request"
     And I should see "Approved"
     And "Julia Child" should be assigned to "Vacation" in "MSK" on 2010-01-01
