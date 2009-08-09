Feature: Adding example data
  Background: 
    Given an Example class is defined

  Scenario: view the example form
    When I request the new example page
    Then I see the new example form
	And selects are visible
	And textareas are visible
	And include_blank selects have an empty options
	And classes from the configuration are in the html
	And all fields have ids

	And the email is marked as required
	And the state select has options

  Scenario: adding an example
    When I submit the new example form
    Then I should see the examples list

  Scenario: adding an invalid example
    When I submit the new example form with invalid data
    Then I see the new example form 
	And I see a required field error message
	And the problem field is highlighted

  Scenario: viewing examples list
    When I submit the new example form
    And I request the examples index page
    Then I should see the example I created 
    And I see a link to edit the example
