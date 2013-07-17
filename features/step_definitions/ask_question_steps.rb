Given(/^I am a visitor and on ask a question page$/) do
  visit asks_url
end

Given(/^I fill in "(.*?)" with "(.*?)"$/) do |field, value|
  fill_in field, :with => value
end

When(/^I press "(.*?)"$/) do |button|
  find_button(button).click
end

Then(/^page should have notice message "(.*?)"$/) do |msg|
  page.should have_selector('.alert', :text => msg)
end
