Feature: Manage sections
  In order to mimic the organizational structure of the department
  A site administrator
  Should be able to manage sections

Scenario: Create a section
   When I create a new section
   Then I should see "Successfully created section"

Scenario: Update a section
   When I update an existing section
   Then I should see "Successfully updated section"
