module Enumerable

  # Maps an enumerable to a hash.
  #
  # It takes a block that should map each element of the enumerable to a [key, value] array. In
  # case a key appears more than once, the result contains the last value. For example:
  #
  # [3, 4].map_hash { |n| [n * 2, n ** 2] }   #=> {6 => 9, 8 => 16}
  # [-3, 3].map_hash { |n| [n.abs, n] }       #=> {3 => 3}
  def map_hash(&block)
    Hash[map(&block)]
  end
end
