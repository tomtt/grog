module GitHelpers
  def set_root_path_variable
    @root_dir ||= File.expand_path(File.dirname(__FILE__) + '/../..')
  end

  def set_repo_path_variable(name)
    set_root_path_variable
    unless @tmp_git_repo_dir
      @features_dir = File.expand_path(File.dirname(__FILE__) + '/..')
      @tmp_git_repo_dir = File.join(@features_dir, 'tmp', name)
    end
  end

  def delete_temporary_test_repo
    if File.exists?(@tmp_git_repo_dir)
      `rm -rf #{@tmp_git_repo_dir}`
    end
  end

  def untar_tarball_to_test_repo_location(tarball_name)
    tarball_path = File.join(@root_dir, 'spec', tarball_name + '.tgz')
    Dir.chdir(File.join(@features_dir, 'tmp'))
    `tar zxf #{tarball_path}`
  end
end

Given /^a test git repo$/ do
  name = 'git_repo'
  set_repo_path_variable(name)
  delete_temporary_test_repo(name)
  `mkdir #{@tmp_git_repo_dir}`
  `git init #{@tmp_git_repo_dir}`
end

Given /^a test git repo extracted from the "([^\"]*)" tarball$/ do |tarball_name|
  set_repo_path_variable(tarball_name)
  delete_temporary_test_repo
  untar_tarball_to_test_repo_location(tarball_name)
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

World(GitHelpers)
