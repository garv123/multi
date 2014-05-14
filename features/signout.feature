Feature: signout
  In order to protect my spaces from unauthorized users
  As a space administrator
  I want to sign out of the app

  Scenario: signout success
    Given I am logged in
    When I click "Sign out"
    Then I am signed out of the app
