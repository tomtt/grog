Given /^a test git repo$/ do
  features_dir = File.expand_path(File.dirname(__FILE__) + '/..')
  @root_dir = File.expand_path(File.dirname(__FILE__) + '/../..')
  @tmp_git_repo_dir = File.join(features_dir, 'tmp', 'git_repo')
  if File.exists?(@tmp_git_repo_dir)
    `rm -rf #{@tmp_git_repo_dir}`
  end
  `mkdir #{@tmp_git_repo_dir}`
  `git init #{@tmp_git_repo_dir}`
end

Given /^the test git repo has a file called "([^\"]*)" containing "([^\"]*)"$/ do |filename, content|
  File.open(File.join(@tmp_git_repo_dir, filename), 'w') do |file|
    file.puts content
  end
end

Given /^a commit of all changes to the test git repo with message "([^\"]*)"$/ do |message|
  Dir.chdir(@tmp_git_repo_dir)
  `git add -A .`
  `git commit -m "#{message}"`
end

Given /^a checkout in the git repo with new branch called "([^\"]*)"$/ do |branch_name|
  Dir.chdir(@tmp_git_repo_dir)
  `git checkout -b #{branch_name} 2> /dev/null`
end
