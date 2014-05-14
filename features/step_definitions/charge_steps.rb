Given /^I have a space "([^"]*)" with at least one member$/ do |subdomain|
  stub_request(
    :get, "https://#{subdomain}.cobot.me/api/memberships").to_return(
    :status => 200, :body => "[{\"id\": \"1\", \"address\": {\"name\": \"johnny doe\"}}, {\"id\": \"2\", \"address\": {\"name\": \"jane smith\"}}]", :headers => {})
end

When /^I visit the space for "([^"]*)"$/ do |subdomain|
  visit space_path(subdomain)
end

Then /^I will see a form for submitting charges to "([^"]*)"$/ do |subdomain|
  page.should have_css("form[method=post][action='/spaces/#{subdomain}/charge']")
  @id = subdomain
end

When /^I select a member to charge$/ do
  select "johnny doe", from: "membership"
end

When /^I enter "([^"]*)" euros as the amount$/ do |number|
  fill_in "Amount", with: number
  @amount = number
end

When /^I enter "([^"]*)" as the description$/ do |description|
  fill_in "Description", with: description
  @description = description
end

When /^I click Charge$/ do
  stub_request(
    :post, "https://#{@id}.cobot.me/api/memberships/1/charges?amount=#{@amount}&description=#{@description}").to_return(
    :status => 201, :body => "abc", :headers => {:status => 201})

  stub_request(
    :post, "https://#{@id}.cobot.me/api/memberships/1/charges?amount=&description=").to_return(
    :status => 422, :body => "abc", :headers => {:status => 422})

  stub_request(:post, "https://#{@id}.cobot.me/api/memberships//charges?amount=#{@amount}&description=#{@description}").to_return(
    :status => 500, :body => "", :headers => {})

  click_button("Charge")
end

Then /^I will see a success message$/ do
  page.should have_selector("*", :text => "Charges successful")
end

Then /^I will see an error message$/ do
  page.should have_selector("*", :text => "All fields must be filled in")
end

Then /^I will see a warning message$/ do
  page.should have_selector("*", :text => "Unrecognized server response")
end

Given /^I have a space "([^"]*)" with no members$/ do |subdomain|
  stub_request(
    :get, "https://#{subdomain}.cobot.me/api/memberships").to_return(
    :status => 200, :body => "[]", :headers => {})
end

Then /^I will see a notice that the space has no members$/ do
  page.should have_selector("*", :text => "There are no members registered")
end

Then /^the form will not be able to be submitted$/ do
  page.should have_css("input.btn[disabled=disabled]")
end

Then /^I will be returned to the spaces page$/ do
  page.should have_selector("*", :text => "Select a subdomain")
end

Then /^I will see an unauthorized user error$/ do
  page.should have_selector("*", :text => "You do not have admin privileges for that subdomain.")
end

