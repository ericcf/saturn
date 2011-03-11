Feature: Manage members
  In order to assign physicians to shifts
  A section administrator
  Should be able to manage section members

Background:
  Given a section "General"
    And a "Faculty" member "Spud McKenzie"
    And I am an authenticated section administrator for "General"

Scenario: Add a member
   When I go to the memberships page for "General"
    And I follow "Add Members"
   Then I should be on the add new memberships page for "General"
   When I check "Spud McKenzie" within "form"
    And I press "Update Section"
   Then I should see "Successfully updated section"
    And there should be a user that belongs to "Spud McKenzie"
