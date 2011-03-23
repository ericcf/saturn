Feature: Manage weekly schedule
  In order to assign physicians to shifts
  A section administrator
  Should be able to manage weekly schedules

Background:
  Given a section "Body"
    And a shift "PM" in the section "Body"
    And I am an authenticated section administrator for "Body"

@javascript
Scenario: View the edit page
   Then I should be able to view the edit weekly schedule page for "Body"

@javascript
Scenario: Select the schedule that belongs to a specific date
   When I go to the edit weekly schedule page for "Body"
    And I click "#date-selector"

@javascript
Scenario: Add a new assignment
  Given a section "Body" with a "Fellows" member "Colonel Sanders"
   When I go to the edit weekly schedule page for "Body"
    And I click ".shiftDay:first"
    And I click ".physician-name:first"
   Then I should see the ajax result /last saved: \d\d\d\d/
    And "Colonel Sanders" should be assigned to "PM" in "Body"

@javascript
Scenario: Delete an assignment
  Given a section "Body" with a "Fellows" member "Colonel Sanders"
    And a weekly schedule for "Body" that begins Monday
    And "Colonel Sanders" is assigned to "PM" in "Body" today
   When I go to the edit weekly schedule page for "Body"
    And I click ".assignment"
    And I press "Delete assignment"
   Then I should not see "C. Sanders" within ".shiftDay"

@javascript
Scenario: Publish a weekly schedule
  Given a weekly schedule for "Body" that begins 2010-11-22
   When I go to the edit weekly schedule page for "Body" on 2010-11-22
   Then I should see "Publish"
   When I check "schedule-is-published"
   Then I should see "status: published"

@javascript
Scenario: Add a shift week note
  When I go to the edit weekly schedule page for "Body"
   And I update text field "shift-week-note" with "my note"
  Then I should see the ajax result /last saved: \d\d\d\d/
   And the "shift_week_note" field should contain "my note"
