class Array
  # Maps an array of pairs to a hash
  #
  # [[1, 2], [3, 4]].to_h  #=> {1 => 2, 3 => 4}
  # [[1, 2], [1, 3]].to_h  #=> {1 => 3}
  #
  # Note that this is just a postfix notation for Hash[array]
  def to_h
    map_hash { |a| a }
  end
end
