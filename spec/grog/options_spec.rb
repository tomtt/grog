require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'grog/options'

describe Grog::Options do
  describe "number of commits to show" do
    it "should be set by the -n argument" do
      options = Grog::Options.parse(%w{-n 34})
      options.number_of_commits_to_show.should == 34
    end

    it "should be 10 by default" do
      Grog::Options.new([]).number_of_commits_to_show.should == 10
    end
  end

  describe "show datetimes" do
    it "should be set if the -d flag is passed" do
      options = Grog::Options.parse(%w{-d})
      options.show_datetimes.should be_true
    end

    it "should be false by default" do
      Grog::Options.new([]).show_datetimes.should be_false
    end
  end

  describe "help" do
    it "should print help info if the --help flag is passed" do
      pending "how to ignore exception thrown by exit?"
      options = Grog::Options.new([])
      $stdout.should_receive(:write).with(options.instance_variable_get('@opts').to_s)
      Grog::Options.new(%w{--help})
    end

    it "should print help info if the -h flag is passed" do
      pending "how to ignore exception thrown by exit?"
      options = Grog::Options.new([])
      $stdout.should_receive(:write).with(options.instance_variable_get('@opts').to_s)
      Grog::Options.new(%w{-h})
    end

    it "should exit" do
      $stdout.stub!(:write)
      lambda { Grog::Options.new(%w{--help}) }.should raise_error(SystemExit)
    end
  end

  describe "version" do
    it "should print it's version and exit" do
      expected_version = "grog v" + File.read(File.join(File.dirname(__FILE__), '..', '..', 'VERSION'))
      $stdout.should_receive(:write).with(expected_version)
      Grog::Options.new(%w{--version})
    end
  end
end
