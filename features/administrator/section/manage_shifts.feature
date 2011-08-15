Feature: Manage shifts
  So that I can organize physician assignments
  As a section administrator
  I should be able to manage shifts

Scenario: Add a shift
   When I add a shift to a section
   Then I should see "Successfully created shift"

Scenario: Modify a shift title from the shifts management page
   When I modify a shift title from the shifts management page
   Then I should see "Successfully updated section"

Scenario: Add a shift category to an existing shift
   When I add a category to a shift
   Then I should see "Successfully updated shift"

Scenario: Share a shift with another section
   When I share a shift with another section
   Then I should see "Successfully updated shift"

Scenario: Retire a shift
   When I retire a shift
   Then I should see "Successfully updated section"
    And I should see the shift in the list of retired shifts
