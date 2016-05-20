
module CoreExt; module Array

  # Check if all array members are instances of given class(es).
  #
  # @return [Boolean]
  # @param [Array, Class] klasses_allowed Array of classes, or a single class
  # @note Returns <tt>true</tt> if the array is empty.
  def is_array_of?(klasses_allowed)
    if klasses_allowed.kind_of? Array
      fail ArgumentError, "Array of Classes expected. Some members are not instances of Class." \
        unless klasses_allowed.is_array_of?(Class)
    elsif klasses_allowed.kind_of? Class
      klasses_allowed = [klasses_allowed]
    else
      fail ArgumentError, "Class or array of classes expected, #{klasses_allowed.class.name} given"
    end
    return true if self.empty?
    self.map(&:class).uniq.reject{ |klass| klasses_allowed.include?(klass) }.empty?
  end


  # @note Sums array members.
  #
  # @return [nil] If source array contains non-numeric values.
  # @return [Fixnum, Integer, Float]
  def sum
    return nil unless self.is_array_of? [Integer, Float, Fixnum]
    self.inject(0) { |sum, value| sum + value }
  end


  # Boil down values proportionally, to make their sum equal to <tt>target_sum</tt>.
  #
  # @param [Fixnum] target_sum
  # @return [Array] Array of pairs [old value, new_value].
  def reduce_to_sum(target_sum)
    current_sum = self.sum
    gap = current_sum - target_sum
    if gap < 0
      return nil
    elsif gap == 0
      return self.collect { |value| [value, value] }
    else
      reduced = 0
      result = self.collect do |value|
        x = (gap * value) / current_sum # Floats round here
        reduced += x
        [value, value - x]
      end
      # Second pass, as target sum is not reached yet due to rounding of floats
      (gap - reduced).times { |i| result[i][1] -= 1 }
      result
    end
  end

end; end


if defined? Array
  Array.class_eval do
    include CoreExt::Array
  end
end

