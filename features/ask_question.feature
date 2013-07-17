Feature: ask a question
	In order to ask a question
	A visitor
	should see list of responded questions and an ask question form
	
	Scenario Outline: submit a question
		Given I am a visitor and on ask a question page
		And I fill in "visitor_question_email" with "<email>"
		And I fill in "visitor_question_description" with "<description>"
		When I press "Ask"
		Then page should have notice message "<msg>"
		Examples:
		| email | description | msg |
		| abc@abc.com | question 1 | Thanks for your submittion |
		| abc@abc.com | | Please provide valid email and description |
		| | question asked | Please provide valid email and description |
	
		