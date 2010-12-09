Feature: Manage physicians
  In order to manage physician schedules
  A site administrator
  Should be able to manage physicians

Scenario: View the physicians page
  Given I am an authenticated site administrator
   When I go to the physicians page
   Then I should see "Physicians"

Scenario: Create a physician's alias
  Given a physician "Lemony Snicket" in the "Chest" section
    And I am an authenticated site administrator
   When I go to the new physician alias page for "Lemony Snicket"
    And I fill in "physician_alias_short_name" with "L. Snizzo"
    And I fill in "physician_alias_initials" with "LSX"
    And I press "Create Physician alias"
   Then I should see "Successfully created alias"
    And I should see "L. Snizzo"
    And I should see "LSX"

Scenario: Update a physician's alias
  Given a physician "Lemony Snicket" in the "Chest" section
    And the alias "L. Snick", "LLS" for the physician "Lemony Snicket"
    And I am an authenticated site administrator
   When I go to the edit physician alias page for "Lemony Snicket"
    And I fill in "physician_alias_short_name" with "L. Snizzo"
    And I fill in "physician_alias_initials" with "LSX"
    And I press "Update Physician alias"
   Then I should see "Successfully updated alias"
    And I should see "L. Snizzo"
    And I should see "LSX"
