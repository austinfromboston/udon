Feature: Edit example data
  Background: 
    Given an Example class is defined
    And the database is cleared of examples
    And an example has been created

  Scenario: view the example form
    When I request the edit example page
    Then I see existing data in the form
    And the edit form points to the example url
    And the edit form fakes a PUT with a hidden field

  Scenario: update the example
    When the database is cleared of examples
    And an example has been created
    And I send updates to the example
    Then I see the updated info in the list

  Scenario: empty db
    When the database has no examples
    Then there should be nothing in the list

  Scenario: update the example
    When I send invalid updates to the example
    Then I see a required field error message
    And the problem field is highlighted


  Scenario: update checkboxes
    When I send updates to the example
    Then the database contains the checkbox values
