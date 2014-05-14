When /^I sign in with OmniAuth/ do
  visit root_path
  stub_request(:get, "https://www.cobot.me/api/user").to_return(status: 200, headers: {},
    body: {"admin_of" => [{"space_subdomain" => "co-up"}]}.to_json)
  first(:link, "Sign in").click
end

When /^an error occurs with OmniAuth login$/ do
  visit auth_failure_path
end

Then /^I should be logged in$/ do
  page.should have_selector("*", :text => /Select a subdomain/i)
end

Then /^I should see an error message$/ do
  page.should have_selector("*", :text => /Sorry, something went wrong/i)
end
