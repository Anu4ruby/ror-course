Feature: Visit Course Content page
	In order to go through the course contents
	A visitor
	should see list of all contents in the course content page
	
	Scenario: see the introduction content on the list of contents
		Given I am on the home page
		And 'Introduction' is a content
		When I click on Course -Ruby on Rails
		Then page should have 'Introduction'
		 
		