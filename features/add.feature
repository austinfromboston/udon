Feature: Adding example data
  Background: 
    Given an Example class is defined

  Scenario: view the example form
    When I request the new example page
    Then I see the new example form

  Scenario: adding an example
    When I submit the new example form
    Then I should see the examples list

  Scenario: viewing examples list
    When I submit the new example form
    And I request the examples index page
    Then I should see the example I created 
    And I see a link to edit the example
