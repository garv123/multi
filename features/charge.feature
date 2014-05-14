Feature:
  In order to add a new one-time charge to a member's next invoice
  As a space administrator
  I want to submit a charge

  Background: logged in
    Given I am logged in
    And I have a space "my-subdomain" with at least one member

  Scenario: successful charge
    When I visit the space for "my-subdomain"
    Then I will see a form for submitting charges to "my-subdomain"
    When I select a member to charge
    And I enter "5" euros as the amount
    And I enter "lunch" as the description
    And I click Charge
    Then I will see a success message

  Scenario: incomplete form (missing amount and/or description)
    When I visit the space for "my-subdomain"
    Then I will see a form for submitting charges to "my-subdomain"
    When I select a member to charge
    And I click Charge
    Then I will see an error message

  Scenario: incomplete form (missing member)
    When I visit the space for "my-subdomain"
    Then I will see a form for submitting charges to "my-subdomain"
    When I enter "5" euros as the amount
    And I enter "lunch" as the description
    And I click Charge
    Then I will see a warning message

  Scenario: no members
    Given I have a space "test2" with no members
    When I visit the space for "test2"
    Then I will see a notice that the space has no members
    And the form will not be able to be submitted

  Scenario: not my subdomain
    When I visit the space for "keep_out"
    Then I will be returned to the spaces page
    And I will see an unauthorized user error
