Feature: Manage members
  In order to assign physicians to shifts
  A section administrator
  Should be able to manage section members

Background:
  Given a section "General"
    And I am an authenticated section administrator for "General"

Scenario: Add a member
  Given a "Faculty" member "Spud McKenzie"
   When I go to the memberships page for "General"
    And I follow "Add Members"
   Then I should be on the add new memberships page for "General"
   When I check "Spud McKenzie" within "form"
    And I press "Update Section"
   Then I should see "Successfully updated section"
    And I should see "McKenzie, Spud"
    And there should be a user that belongs to "Spud McKenzie"

Scenario: Remove a member
  Given a section "General" with a "Faculty" member "Spud McKenzie"
   When I go to the memberships page for "General"
    And I follow "Remove Members"
   When I check "Spud McKenzie"
    And I press "Update Section"
   Then I should see "Successfully updated section"
    And I should not see "McKenzie, Spud"
