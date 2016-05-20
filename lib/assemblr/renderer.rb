
require "rmagick"

class Assemblr; class Renderer
  include Magick

  attr_reader :rows

  def initialize
    @rows = {}
  end


  def add(image, width:, height:, row:)
    img = Image.read(image[:filename]).first.resize_to_fill(width, height)
    @rows[row] ||= ImageList.new
    @rows[row].push(img)
  end


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

