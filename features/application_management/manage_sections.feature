Feature: Manage sections
  In order to mimic the organizational structure of the department
  A site administrator
  Should be able to manage sections

Scenario: Create a section
  Given I am an authenticated site administrator
   When I go to the new section page
    And I fill in "section_title" with "Thorax"
    And I press "Create Section"
   Then I should see "Successfully created section"
    And I should see "Thorax"

Scenario: Update a section
  Given I am an authenticated site administrator
    And a section "Thumb"
   When I go to the edit section page for "Thumb"
    And I fill in "section_title" with "Pinky"
    And I press "Update Section"
   Then I should see "Successfully updated section"
    And I should see "Pinky"
