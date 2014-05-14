Feature: logging in
  In order to manage a large number of one-time charges,
  As a space administrator
  I want to log into the application

  Scenario: login success
    When I sign in with OmniAuth
    Then I should be logged in

  Scenario: login failure
    When an error occurs with OmniAuth login
    Then I should see an error message
