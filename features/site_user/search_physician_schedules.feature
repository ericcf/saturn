Feature: Search physician schedules
  So that I can find schedules quickly
  As a user
  I should be able to find this week's schedule by physician name

Background:
  Given a section "Moon" with a "Faculty" member "Buzz Aldrin"
    And a weekly schedule for "Moon" that begins Monday is published
    And a shift "Float" in the section "Moon"
    And "Buzz Aldrin" is assigned to "Float" in "Moon" today

Scenario: search for a physician by name
  When I go to the physician schedule search page
   And I fill in "query" with "Aldrin"
   And I press "Search Physicians"
  Then I should see "Aldrin, Buzz"
   And I should see "Float"
