
Given(/^I am on the home page$/) do
   
  visit root_url
end

Given(/^(.*) is a content$/) do |detail|
   
  Content.create(content: detail)
end

When(/^I click on Course \-Ruby on Rails$/) do
   
  visit contents_path
end

Then(/^page should have (.*)$/) do |detail|
   
  page.should have_content(detail)
end
