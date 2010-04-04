require 'term/ansicolor'
require 'grog/list_hash'
require 'date'

module Grog
  class GitLog
    @@placeholders = %w{H P an ai s}
    def initialize(options)
      @options = options
      fetch_log
    end

    def self.generate_parsing_arguments
      options = Grog::Options.parse(ARGV)
      generate(:number_of_commits_to_show => options.number_of_commits_to_show,
               :show_datetimes => options.show_datetimes)
    end

    def self.generate(options)
      self.new(options).to_s
    end

    def to_s
      @log_lines.map do |line|
        values = Hash[*@@placeholders.zip(line.split('|||')).flatten]

        sha = GitLog.short_sha1(values['H'])
        date = GitLog.nice_date_format(values['ai'])
        subject = values['s']
        author = values['an']
        branches = branches(values['H'])
        tags = tags(values['H'])

        line =
          Term::ANSIColor.yellow + sha + ' '

        if @options[:show_datetimes]
          line +=
            Term::ANSIColor.green + date + ' '
        end

        line +=
          Term::ANSIColor.reset + subject + ' ' +
          Term::ANSIColor.green + "(#{author})" + Term::ANSIColor.reset

        unless branches.empty?
          line += " B(" + Term::ANSIColor.red + branches.join(' ') + Term::ANSIColor.reset + ")"
        end

        unless tags.empty?
          line += " T(" + Term::ANSIColor.cyan + tags.join(' ') + Term::ANSIColor.reset + ")"
        end

        line + "\n"
      end.join
    end

    protected

    def branches(sha1)
      @branches[sha1]
    end

    def tags(sha1)
      @tags[sha1]
    end

    def self.short_sha1(sha1)
      sha1[0,7]
    end

    def self.nice_date_format(date)
      DateTime.parse(date).strftime('%Y-%m-%d %H:%M')
    end

    def self.lines_of_command(command)
      `#{command}`.split("\n")
    end

    def self.first_line_of_command(command)
      `#{command}`.split("\n").first
    end

    def git_log_command
      format = @@placeholders.map{ |p| "%" + p }.join('|||')
      'git log --pretty=format:"%s" -n %d' % [format, @options[:number_of_commits_to_show]]
    end

    def self.hash_from_rev_names(rev_names, ref_root)
      hash = Hash.new { |hash, key| hash[key] = [] }
      # Instead of running the command for each rev, it should run the
      # command with all of them
      rev_names.each do |rev_name|
        sha1 = GitLog.first_line_of_command("git rev-parse #{ref_root}/#{rev_name}")
        hash[sha1] << rev_name
      end
      hash
    end

    def branch_names_from_branch_command(type = :local)
      case type
      when :local
        option = ''
        ref = 'refs/heads'
      when :remote
        option = '-r '
        ref = 'refs/remotes'
      else
        raise "Unknown type of branch: %s" % type
      end
      branch_names = GitLog.lines_of_command("git branch #{option}--no-color").
        map { |line| line[2..-1].split(' -> ').first }
      GitLog.hash_from_rev_names(branch_names, ref)
    end

    def get_all_branches
      local_branches = branch_names_from_branch_command(:local)
      remote_branches = branch_names_from_branch_command(:remote)
      @branches = Grog::ListHash.merge_lists(local_branches, remote_branches)
    end

    def get_all_tags
      tag_names = GitLog.lines_of_command("git tag")
      @tags = GitLog.hash_from_rev_names(tag_names, 'refs/tags')
    end

    def fetch_log
      get_all_branches
      get_all_tags
      @log_lines = GitLog.lines_of_command(git_log_command)
    end
  end
end
