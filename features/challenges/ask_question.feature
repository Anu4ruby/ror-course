Feature: ask a question
	In order to ask a question
	A visitor
	should see list of responded questions and an ask question form
	
	Scenario Outline: submit a question
		Given I am a visitor and on ask a question page
		And I fill in "Email" with "<email>"
		And I fill in "Description" with "<description>"
		When I press "Ask"
		Then page notices with message "<msg>"
		
		Examples:
		| email | description | msg |
		| abc@abc.com | question 1 | Thanks for your submission |
		| abc@abc.com | | Please provide valid email and description |
		| | question asked | Please provide valid email and description |
		
	Scenario: see list of responded questions
		Given there's 20 responded questions
		When I go to ask a question page
		Then I should see 10 latest responded questions
	