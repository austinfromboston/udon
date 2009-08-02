Feature: Delete example data
  Background: 
    Given an Example class is defined
    And an example has been created

  Scenario: delete example data
    When I request the edit example page
    Then I see the delete button in the page
    And the delete form fakes a DELETE with a hidden field
    
    When I submit the delete form
    Then the example no longer exists

