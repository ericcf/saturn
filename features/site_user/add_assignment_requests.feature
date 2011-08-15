Feature: Add assignment requests
  So that I can notify the administrators of my intentions
  As an authenticated user
  I should be able to request assignment days

Background:
  Given a section has a member physician and an associated shift

Scenario: Submit a new assignment request as a section administrator
  Given I am an authenticated section administrator for the section
   When I submit a new assignment request
   Then I should see "Successfully submitted assignment request"

Scenario: Submit a new assignment request as a physician
  Given I am an authenticated user associated with the physician
   When I submit a new assignment request
   Then I should see "Successfully submitted assignment request"
