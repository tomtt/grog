module Grog
  class ListHash
    # Merges hashes that have lists as values: when merging identical
    # keys the lists are added
    #
    # Hash.merge_lists({:a => [1, 2]}, {:a => [3]}) => {:a => [1, 2, 3] }
    def self.merge_lists(h1, h2)
      merged_hash = h1.dup
      h2.keys.each do |key|
        if merged_hash.has_key?(key)
          merged_hash[key] += h2[key]
        else
          merged_hash[key] = h2[key]
        end
      end
      merged_hash
    end
  end
end
