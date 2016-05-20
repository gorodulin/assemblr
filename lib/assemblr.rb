
require_relative "assemblr/argv_parser"
require_relative "assemblr/default"
require_relative "assemblr/flickr_api"
require_relative "assemblr/renderer"
require_relative "partitioner"
require_relative "random_line_picker"

# Main class of the app.
#
class Assemblr

  def initialize(options)
    @options = Default.options.merge(options)
    if @options[:is_adjust8px]
      @options[:row_height_px] = (@options[:row_height_px]/8).ceil * 8
    end
    @flickr_helper = FlickrApi.new({
      api_key: @options[:flickr_api_key],
      api_secret: @options[:flickr_api_secret],
    })

    report "Target row height: #{@options[:row_height_px]}"
    report "Number of images to collect: #{@options[:number_of_images]}"
  end


  # Delete downloaded files.
  def clear_cache!(images)
    report "Clearing cache...", newline: false
    images.each do |image|
      ::File.delete(image[:filename])
    end
    report "done"
  end


  # Group images into rows, render result to output file.
  #
  # @param [Hash] images
  def combine!(images)
    target_widths = images.collect do |image|
      [image, ((image[:width] * @options[:row_height_px]) / image[:height]).round]
    end.to_h # Hash of pairs: {image => target_width}

    # Partition images into groups of same width (rows).
    # Build a hash {row_hash1 => row_width1, ...}.
    report "Grouping images into #{@options[:number_of_rows]} rows...", newline: false
    rows_vs_widths = ::Partitioner.new(no_of_sets: @options[:number_of_rows]).distribute(target_widths)
    rows, row_widths = *rows_vs_widths.to_a.transpose
    narrowest_row_width = row_widths.max_by { |width| -width }
    report "done"

    report "Rendering '#{@options[:output_filename]}' ...", newline: false
    renderer = Renderer.new
    # Adjust widths proportionally so that all rows to have identical width.
    rows.each_with_index do |row_hash, row_no|
      widths = *row_hash.values.reduce_to_sum(narrowest_row_width) # Array of pairs [old_width, new_width]
      uncut_widths, cut_widths = *widths.transpose

      row_hash.to_a.each do |i|
        image, uncut_width = *i
        uncut_widths.delete_at( i = uncut_widths.index(uncut_width))
        # Add to final image:
        renderer.add(image, width: cut_widths.delete_at(i), height: @options[:row_height_px], row: row_no)
      end
    end
    renderer.write(output_filename: @options[:output_filename], quality: @options[:output_quality])
    report "ok"
  end


  # Download N images from Flickr.
  #
  # @return [Hash]
  def download!
    report "Temp directory: '#{@options[:temp_dir]}'"

    # Build a list of images to download. (search Flickr).
    images = []
    keywords = @options[:keywords].clone

    until images.count == @options[:number_of_images]
      search_text = keywords.pop || random_word
      report "Downloading '#{search_text}'...", newline: false

      unless image_data = @flickr_helper.find_by_text(search_text)
        report "not found"
        next
      end

      unless size_data = @flickr_helper.size_for(image_data, min_height: @options[:row_height_px])
        report "no valid size found"
        next
      end

      target_filename = "#{@options[:temp_dir]}/#{image_data.id}.jpg"
      unless file = @flickr_helper.download(url: size_data[:url], to: target_filename )
        report "download error"
        next
      end

      images << {
        keyword:  search_text,
        filename: target_filename,
      }.merge(size_data)

      report "ok (#{images.count} of #{@options[:number_of_images]})"
    end

    images
  end


  # Pick a random word from the dictionary file.
  #
  # @note File must contain one word per line.
  #
  # @note Lines containing non-latin characters, spaces and numbers will be skipped.
  #
  # @see RandomLinePicker
  # @return [String]
  def random_word
    @dictionary ||= ::RandomLinePicker.new(filename: @options[:dictionary_file])
    loop do
      word = @dictionary.random_line
      break word if word =~ /\A[a-z]+\Z/i
    end
  end


  # Print out a string if verbose mode is enabled.
  #
  # @param [String] text Text to print.
  # @param [Boolean] newline Append <tt>\n</tt> newline symbol.
  def report(text, newline: true)
    return unless verbose?
    newline ? puts(text) : print(text)
  end


  # Run all actions:
  # * download images
  # * combine them
  # * clear the cache
  def run!
    images = download!
    combine!(images)
    clear_cache!(images)
  end


  def verbose?
    !!@options[:is_verbose]
  end

end

