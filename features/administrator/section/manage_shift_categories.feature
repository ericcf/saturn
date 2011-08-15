Feature: Manage shift categories
  So that I can organize physician assignments
  As a section administrator
  I should be able to manage shift categories

Scenario: Add a new shift category
  When I add a new shift category
  Then I should see "Successfully created category"

Scenario: Update shift category title from the management page
  When I update an existing shift category title from the management page
  Then I should see "Successfully updated section"
