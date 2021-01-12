
  Feature: Calculation check

  Scenario: Verify values on the screen
      Given navigate to site
      When calculation check page available
      Then value count on the screen should be 5:
      And value on the screen should be greater than 0
      And total balance should be correct based on the values listed on the screen
      And values are formatted as currencies
      And the total balance matches the sum of the values


