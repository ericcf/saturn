Feature: Manage members
  In order to assign physicians to shifts
  A section administrator
  Should be able to manage section members

Scenario: Add a member
  Given I add a new member to a section
   Then I should see "Successfully updated section"
    And there should be a user associated with the new section member

Scenario: Remove a member
  Given I remove an existing member from a section
   Then I should see "Successfully updated section"
