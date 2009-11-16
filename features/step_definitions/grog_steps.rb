When /^I run grog on the test git repo$/ do
  Dir.chdir(@tmp_git_repo_dir)
  grog_bin = File.join(@root_dir, 'bin', 'grog')
  @grog_output = `#{grog_bin}`
end

Then /^the output should be$/ do |expected_output|
  @grog_output.should == expected_output
end

Then /^the output ignoring colour codes should be$/ do |expected_output|
  colourless_output = @grog_output.gsub(/\e\[\d+m/, '')
  colourless_output.should == expected_output
end

