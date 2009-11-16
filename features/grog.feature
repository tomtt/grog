Feature: default output of grog
  In order to find out the state of my git repository
  As a developer
  I want to see an overview of my recent commits

  Scenario: running grog with no options
    Given a test git repo extracted from the "test_git_repo" tarball
    When I run grog on the test git repo
    Then the output ignoring colour codes should be
      """
6165a67 Commit B (Tom ten Thij) B(branch_b master origin/master) T(foo v2)
bf5b520 Commit A (Tom ten Thij) B(branch_a foo) T(v1)

      """
