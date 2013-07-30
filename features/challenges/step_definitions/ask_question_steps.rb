Given(/^I am a visitor and on ask a question page$/) do
  visit asks_url
end

Given(/^I fill in "(.*?)" with "(.*?)"$/) do |field, value|
  fill_in field, :with => value
end

When(/^I press "(.*?)"$/) do |button|
  find_button(button).click
end

Then(/^page notices with message "([^\"]*)"$/) do |msg|
  page.should have_content(msg)
end

Given(/^there's (\d+) responded questions$/) do |size|
  size.to_i.times { FactoryGirl.create(:responded_visitor_question) }
end

When(/^I go to ask a question page$/) do
  visit asks_url
end

Then(/^I should see (\d+) latest responded questions$/) do |size|
  qs = VisitorQuestion.responded.first(size.to_i)
  (0...size.to_i).each do |idx|
    page.should have_content(qs[idx].description)
  end
  
end