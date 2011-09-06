Feature: View reports
  In order to assess physician distribution across shifts
  A user
  Should be able to view reports on published schedules

  Background:
    Given a section exists with a title of "IR"
    And section memberships exist with the following attributes:
      | Physician  | Section |
      | Flenderson | IR      |
      | Serrano    | IR      |
    And shifts exist with the following attributes:
      | Shift Title | Section |
      | AM Meeting  | IR      |
      | PM Meeting  | IR      |
    And a weekly schedule exists with the following attributes:
      | Section | Date       | Published? |
      | IR      | Sep 5 2011 | Yes        |
    And assignments exist with the following attributes:
      | Physician  | Shift      | Date       |
      | Serrano    | AM Meeting | Sep 5 2011 |
      | Serrano    | AM Meeting | Sep 6 2011 |
      | Serrano    | AM Meeting | Sep 7 2011 |
      | Serrano    | AM Meeting | Sep 8 2011 |
      | Serrano    | AM Meeting | Sep 9 2011 |
      | Flenderson | AM Meeting | Sep 6 2011 |
      | Flenderson | PM Meeting | Sep 9 2011 |
    And I am viewing the reports page for "IR"

  Scenario: View full week report
    When I select the following dates for the report:
      | Start      | End         |
      | Sep 5 2011 | Sep 11 2011 |
    When I press the "Get Report" button
    Then I should see the following table rows:
      |                  | Faculty | MF  | JS  |
      | AM Meeting (0.5) | 3.0     | 0.5 | 2.5 |
      | PM Meeting (0.5) | 0.5     | 0.5 |     |

  Scenario: View partial week report
    When I select the following dates for the report:
      | Start      | End         |
      | Sep 5 2011 | Sep 7 2011 |
    When I press the "Get Report" button
    Then I should see the following table rows:
      |                  | Faculty | MF  | JS  |
      | AM Meeting (0.5) | 2.0     | 0.5 | 1.5 |
      | PM Meeting (0.5) |         |     |     |
