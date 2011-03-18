Feature: Manage shifts
  So that I can organize physician assignments
  As a section administrator
  I should be able to manage shifts

Background:
  Given a section "Throat"
    And I am an authenticated section administrator for "Throat"
    And a shift "Meeting" in the "Throat" section
    And I go to the shifts management page for "Throat"

Scenario: View shift management page
   Then I should see "Manage Shifts"

Scenario: Add a shift
   When I follow "Add Shift"
    And I fill in "Title" with "Floater"
    And I press "Create Shift"
   Then I should see "Successfully created shift"

Scenario: Modify a shift title from the shifts management page
   When I fill in "section[shifts_attributes][0][title]" with "Meeting 1"
    And I press "Update Section"
   Then I should see "Successfully updated section"
    And the "section[shifts_attributes][0][title]" field should contain "Meeting 1"

Scenario: Add a shift category
  Given a shift tag "PM" in the "Throat" section
   When I follow "edit" within "#current_shifts .shift:first"
    And I check "PM" within "#shift_shift_tags_input"
    And I press "Update Shift"
   Then I should see "Successfully updated shift"
    And I should see "PM" within "#current_shifts .shift:first"

Scenario: Share a shift with another section
  Given a section "Ear"
   When I follow "edit" within "#current_shifts .shift:first"
    And I check "Ear" within "#shift_sections_input"
    And I press "Update Shift"
   Then I should see "Successfully updated shift"
    And I should see "Ear" within "#current_shifts .shift:first"
