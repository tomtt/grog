require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'grog/git_log'

describe Grog::GitLog do
  describe ".nice_date_format" do
    it "should return the correct UTC date in the '%Y-%m-%d %H:%M'" do
      pending
      Grog::GitLog.nice_date_format("2010-05-04 02:39:41 +0100").should ==
        "2010-05-04 03:39"
    end
  end
end
