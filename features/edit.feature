Feature: Edit example data
  Background: 
    Given an Example class is defined
    And an example has been created

  Scenario: view the example form
    When I request the edit example page
      Then I see existing data in the form
      And the edit form points to the example url
      And the edit form fakes a PUT with a hidden field

  Scenario: update the example
    When I send updates to the example
    Then I see the updated info in the list

  Scenario: update checkboxes
    When I send updates to the example
    Then the database contains the checkbox values
