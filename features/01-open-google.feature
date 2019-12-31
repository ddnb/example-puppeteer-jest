@Google
Feature: openGoogle
  Anyone can open google web page

  Scenario: openGoogle
    Given Someone want to open google
    When Open and goto google web page
    Then Verify that google should open