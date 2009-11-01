Feature: default output of grog
  In order to find out the state of my git repository
  As a developer
  I want to see an overview of my recent commits

  Scenario: running grog with no options
    Given a test git repo
    And the test git repo has a file called "file_a" containing "I am A"
    And a commit of all changes to the test git repo with message "Commit A"
    And a checkout in the git repo with new branch called "branch_a"
    And the test git repo has a file called "file_b" containing "I am B"
    And a commit of all changes to the test git repo with message "Commit B"
    When I run grog on the test git repo
    Then the output should be
      """
Commit B
Commit A

      """
