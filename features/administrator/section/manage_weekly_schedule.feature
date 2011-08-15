Feature: Manage weekly schedule
  In order to assign physicians to shifts
  A section administrator
  Should be able to manage weekly schedules

@javascript
Scenario: Add a new assignment
  When I add a new assignment
  Then I should see the last saved date updated

@javascript
Scenario: Delete an assignment
  When I delete an existing assignment
  Then I should not see the assignment in the schedule

@javascript
Scenario: Publish a new weekly schedule
  When I publish a new weekly schedule
  Then I should see "status: published"

@javascript
Scenario: Publish an existing weekly schedule
  When I publish an existing weekly schedule
  Then I should see "status: published"

@javascript
Scenario: Add a shift week note to a new weekly schedule
  When I add a shift week note to a new weekly schedule
  Then I should see the last saved date updated
   And I should see the text of the new shift week note
