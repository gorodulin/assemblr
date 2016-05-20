
# This class solves "Partition problem"
# See: https://en.wikipedia.org/wiki/Partition_problem
#
# Yep, it's tricky
#
# Note: this class is structure-agnostic, it can group objects of any kind.
class Partitioner

  attr_accessor :no_of_sets
  attr_accessor :no_of_passes


  def initialize(no_of_sets: 3, no_of_passes: 5)
    @no_of_sets   = no_of_sets
    @no_of_passes = no_of_passes
  end


  # Groups pairs into sets (partition).
  # Returns groups of pairs, grouped by closest sums of values.
  #
  # Input:  { obj1: size1, obj2: size2 ... sizeN: valN }
  # Result: { {obj1: size1} => sum1, {obj2: size2, obj5: size5} => sum2, {obj3: size3, ...} => sum3, ...}
  def distribute(hash)
    pieces = hash.sort_by { |k, v| -v } # Reverse sort.

    # Helper, calculates size of set
    size_of = lambda do |n|
      members = pieces.select { |piece| piece[2] == n }
      members.inject(0) { |sum, piece| sum + piece[1] }
    end

    # Recursively compare sizes of pieces, belonging to different sets,
    # from widest to narsetest, and swap them if this action will decrease the larger set size.
    no_of_passes.times do |t|
      pieces.each_with_index do |piece_a, i|

        unless piece_a[2] # At first pass, put the piece into the smallest set.
          piece_a[2] = (1..no_of_sets).max_by { |n| -size_of[n] } # A smallest set
          next
        end

        pieces.drop(i + 1).each do |piece_b|
          set_a, set_b = piece_a[2], piece_b[2]
          next if set_a == set_b
          sets_gap = size_of[set_a] - size_of[set_b]
          next if sets_gap <= 0

          # Move piece to another set, if difference is big enough.
          if piece_a[1] < sets_gap
            piece_a[2] = piece_b[2]
            redo
          end

          # Swap pieces if this action will decrease difference between sets.
          if sets_gap > (size_of[set_b] - size_of[set_a] + (piece_a[1] - piece_b[1])*2)
            piece_a[2], piece_b[2] = piece_b[2], piece_a[2] # Swap pieces.
            redo
          end
        end

      end
    end # ...times

    # Convert result into array of hashes.
    result = Array.new(no_of_sets) { Hash.new }
    pieces.each do |p|
      piece_object, piece_size, set_no = p[0], p[1], p[2]
      result[set_no - 1][piece_object] = piece_size
    end
    result.each_with_index do |set, i|
      result[i] = [set, size_of[i+1]]
    end
    result.to_h
  end

end

