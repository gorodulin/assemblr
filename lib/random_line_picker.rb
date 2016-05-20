
# This class picks a random line from a text file of ANY size.
#
# My original SO anwer is here http://stackoverflow.com/a/14919703/567539
class RandomLinePicker

  attr_accessor :filename  # :nodoc:
  attr_accessor :blocksize # :nodoc:


  # @param [String] filename Multiline text file.
  # @param [Fixnum] blocksize Read buffer size.
  def initialize(filename:, blocksize: 1024)
    @filename  = filename
    @blocksize = blocksize
  end


  # Pick a random line.
  #
  # @return [String]
  def random_line
    line = ""
    File.open(@filename) do |file|
      initial_position = rand(File.size(@filename) - 1) + 1 # Random pointer position. Not a line number!
      pos = Array.new(2).fill(initial_position) # Array [prev_position, current_position].

      # Find the beginning of the current line.
      begin
        pos.push([pos[1] - @blocksize, 0].max).shift # Calc new position.
        file.pos = pos[1] # Move pointer backward within file.
        offset = (n = file.read(pos[0] - pos[1]).rindex(/\n/)) ? n + 1 : nil
      end until pos[1] == 0 || offset
      file.pos = pos[1] + offset.to_i

      # Collect line text till the end.
      begin
        data = file.read(@blocksize)
        line.concat((p = data.index(/\n/)) ? data[0, p.to_i] : data)
      end until file.eof? or p
    end
    line
  end

end

