Feature: Manage shift categories
  So that I can organize physician assignments
  As a section administrator
  I should be able to manage shift categories

Background:
  Given a section "Throat"
    And I am an authenticated section administrator for "Throat"
    And a shift tag "AM" in the section "Throat"
    And I go to the shift categories management page for "Throat"

Scenario: View shift categories management page
  Then I should see "Manage Shift Categories"

Scenario: Add a new shift category
  When I follow "Add Category"
   And I fill in "Title" with "Non-clinical"
   And I press "Create Shift tag"
  Then I should see "Successfully created category"

Scenario: Update shift category title from the management page
  When I fill in "section[shift_tags_attributes][0][title]" with "PM"
   And I press "Update Section"
  Then I should see "Successfully updated section"
   And the "section[shift_tags_attributes][0][title]" field should contain "PM"
