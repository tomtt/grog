require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'grog/list_hash'

describe Grog::ListHash do
  it "should add lists that are the values of identical keys" do
    hash1 = {:a => [1, 2], :b => [4]}
    hash2 = {:a => [3], :c => [5]}
    expected_hash = {:a => [1, 2, 3], :b => [4], :c => [5] }
    Grog::ListHash.merge_lists(hash1, hash2).should == expected_hash
  end

  it "should be an empty hash if both arguments are empty" do
    Grog::ListHash.merge_lists({}, {}).should == {}
  end

  it "should be the first hash if the second one is empty" do
    hash = { :x => 3 }
    Grog::ListHash.merge_lists(hash, {}).should == hash
  end

  it "should be the second hash if the first one is empty" do
    hash = { :x => 3 }
    Grog::ListHash.merge_lists({}, hash).should == hash
  end

  it "should not modify the first hash" do
    hash1 = {:a => [1]}
    hash2 = {:a => [2]}
    Grog::ListHash.merge_lists(hash1, hash2)
    hash1[:a].should == [1]
  end

  it "should not modify the second hash" do
    hash1 = {:a => [1]}
    hash2 = {:a => [2]}
    Grog::ListHash.merge_lists(hash1, hash2)
    hash2[:a].should == [2]
  end
end
