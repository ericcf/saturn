Feature: Manage assignment requests
  So that I can keep the schedule up to date
  As a section administrator
  I should be able to manage physician assignment requests

Scenario: Be notified of a new request
  Given an assignment request is submitted
   Then I should have been notified about the new assignment request

Scenario: Approve a pending request
  Given I approve a pending assignment request
   Then I should see "Successfully approved assignment request"
    And the physician should have been notified about her approved request
    And assignments should have been created for the approved request
