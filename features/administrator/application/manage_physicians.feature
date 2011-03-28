Feature: Manage physicians
  In order to manage physician schedules
  A site administrator
  Should be able to manage physicians

Scenario: Create a physician's alias
   When I create an alias for a physician
   Then I should see "Successfully created alias"

Scenario: Update a physician's alias
   When I update an alias for a physician
   Then I should see "Successfully updated alias"
