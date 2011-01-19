Feature: Manage weekly schedule
  In order to assign physicians to shifts
  A section administrator
  Should be able to manage weekly schedules

Scenario: View the edit page
  Given a section "Body"
    And I am an authenticated section administrator for "Body"
   Then I should be able to view the edit weekly schedule page for "Body"

Scenario: Create a new weekly schedule
  Given a section "Body"
    And I am an authenticated section administrator for "Body"
   When I go to edit weekly schedule page for "Body"
    And I press "Create Weekly schedule"
   Then I should see "Successfully created schedule"

Scenario: Update and publish an existing weekly schedule
  Given a section "Body"
    And a weekly schedule for "Body" that begins on 2010-11-22
    And I am an authenticated section administrator for "Body"
   When I go to edit weekly schedule page for "Body" on 2010-11-22
    And I press "Update Weekly schedule"
   Then I should see "Successfully updated schedule"
    And I should see "Unpublished"
   When I check "weekly_schedule_is_published"
    And I press "Update Weekly schedule"
   Then I should see "Published"
