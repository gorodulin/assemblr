
require "rmagick"

class Assemblr; class Renderer
  include Magick

  attr_reader :rows # :nodoc:

  def initialize
    @rows = {}
  end


  # Add image to the "patchwork".
  #
  # @param [Hash] image A hash with image details. Must contain :filename key.
  # @param [Fixnum] width Width in pixels.
  # @param [Fixnum] height Height in pixels.
  # @param row unique idenitifier of any kind.
  def add(image, width:, height:, row:)
    img = Image.read(image[:filename]).first.resize_to_fill(width, height)
    @rows[row] ||= ImageList.new
    @rows[row].push(img)
  end


  # Render the final image (patchwork).
  #
  # @param [String] output_filename
  # @param [Fixnum] quality JPEG quality 1% - 100%
  def write(output_filename:, quality: 10)
    out_image = ImageList.new

    # Add rows to big picture
    @rows.values.each do |row|
      out_image.push(row.append(false))
    end

    out_image.append(true).write(output_filename) do
      self.format = "JPEG"
      self.quality = quality
    end
  end

end; end

