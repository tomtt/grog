require 'optparse'

module Grog
  class Options
    attr_accessor :number_of_commits_to_show, :show_datetimes

    def self.parse(argv)
      Options.new(argv)
    end

    def initialize(argv)
      @opts = OptionParser.new

      @number_of_commits_to_show = 10
      @opts.on("-n=N", "number of commits to show", Integer) { |val| @number_of_commits_to_show = val }

      @show_datetimes = false
      @opts.on("-d", "show datetimes") { @show_datetimes = true }
      @opts.on_tail("-h", "--help", "Show this message") do
        puts @opts
        exit
      end
      @opts.on_tail("--version", "Show the version of the grog gem") do
        puts "grog v" + `cat VERSION`
      end

      @rest = @opts.parse(argv)
    end
  end
end
