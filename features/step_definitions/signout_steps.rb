Given /^I am logged in$/ do
  visit root_path
  stub_request(:get, "https://www.cobot.me/api/user").to_return(status: 200,
    body: {"admin_of" => [{"space_subdomain" => "co-up"}]}.to_json)
  first(:link, "Sign in").click
end

When /^I click "([^"]*)"$/ do |subdomain_link|
  click_link subdomain_link
end

Then /^I am signed out of the app$/ do
  page.should have_selector("*", :text => /You have been signed out/)
end

