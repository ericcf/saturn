Feature: Manage members
  In order to assign physicians to shifts
  A section administrator
  Should be able to manage section members

Scenario: View the membership page
  Given a section "General"
    And I am an authenticated section administrator for "General"
   When I go to manage new memberships page for "General"
   Then I should see "Add Members"
