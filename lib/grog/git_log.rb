require 'term/ansicolor'

module Grog
  class GitLog
    @@placeholders = %w{H P an ai s}
    def initialize(options)
      @options = options
      fetch_log
    end

    def self.print(options)
      puts self.new(options).to_s
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

        line
      end
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

    def self.hash_from_rev_names(rev_names)
      hash = Hash.new { |hash, key| hash[key] = [] }
      rev_names.each do |rev_name|
        sha1 = GitLog.first_line_of_command("git rev-parse #{rev_name}")
        hash[sha1] << rev_name
      end
      hash
    end

    def get_all_branches
      branch_names = GitLog.lines_of_command("git branch -a --no-color --no-track").
        map { |line| line[2..-1].split(' -> ').first }
      @branches = GitLog.hash_from_rev_names(branch_names)
    end

    def get_all_tags
      tag_names = GitLog.lines_of_command("git tag")
      @tags = GitLog.hash_from_rev_names(tag_names)
    end

    def fetch_log
      get_all_branches
      get_all_tags
      @log_lines = GitLog.lines_of_command(git_log_command)
    end
  end
end
