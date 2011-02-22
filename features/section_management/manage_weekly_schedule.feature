Feature: Manage weekly schedule
  In order to assign physicians to shifts
  A section administrator
  Should be able to manage weekly schedules

Background:
  Given a section "Body"
    And I am an authenticated section administrator for "Body"

@javascript
Scenario: View the edit page
   Then I should be able to view the edit weekly schedule page for "Body"

@javascript
Scenario: Publish a weekly schedule
    And a weekly schedule for "Body" that begins on 2010-11-22
   When I go to edit weekly schedule page for "Body" on 2010-11-22
   Then I should see "Publish"
   When I check "schedule-is-published"
   Then I should see "status: published"
