
require "pathname"
require "optparse"

class Assemblr; class ArgvParser

  # Return hash of options or prints summary and exit.
  #
  # @param [Array] args List of command-line arguments
  # @example
  #   Assemblr::ArgvParser.parse_arguments(ARGV)
  # @return [Hash] Hash of parameters
  def self.parse_arguments(args)

    # Default values
    options = Assemblr::Default.options

    opt_parser = OptionParser.new do |opts|
      opts.version = "1.0"
      opts.banner = "Tool to combine Flickr images into a patchwork.\nUsage: #{$0} [options]"

      opts.separator "\nSpecific options:"

      desc = "Output file name."
      opts.on("-o", "--out-file FILE", desc) do |path|
        options[:output_filename] = path
      end

      desc = "Number of images to fetch and assemble. Default: 10"
      opts.on("-t", "--total NUMBER", OptionParser::DecimalInteger, desc) do |number|
        options[:number_of_images] = number
      end

      desc = "Number of rows. Default: 3"
      opts.on("-r", "--rows NUMBER", OptionParser::DecimalInteger, desc) do |number|
        options[:number_of_rows] = number
      end

      desc = "Fetch images by given comma-separated keywords"
      opts.on("--keywords x,y,z", Array, desc) do |list|
        options[:keywords] = list.collect do |kw|
          kw.strip.downcase
        end.uniq
      end

      desc = "Row height in pixels. Default: #{options[:row_height_px]}"
      opts.on("--row-height PIXELS", OptionParser::DecimalInteger, desc) do |px|
        options[:row_height_px] = px
      end

      desc = "Adjust dimensions so that they're dividable by 8px. Default: false"
      opts.on("--[no-]adjust-8px", desc) do |bool|
        options[:is_adjust8px] = bool
      end

      desc = "Set output JPEG quality. Default: 90"
      opts.on("-z", "--jpeg-quality PERCENT", OptionParser::DecimalInteger, desc) do |percent|
        options[:output_quality] = percent
      end

      desc = "Dictionary file, one word per line. Default: #{options[:dictionary_file]}"
      opts.on("-d", "--dictionary FILEPATH", desc) do |path|
        options[:dictionary_file] = path
        fail ArgumentError, "File '#{path}' is not readable" unless File.readable?(path)
      end

      desc = "Run silently"
      opts.on("-q", "--[no-]quiet", desc) do |bool|
        options[:is_verbose] = !bool
      end

      desc = "Show debug information if something goes wrong. Default: not shown"
      opts.on("--[no-]trace", desc) do |bool|
        options[:is_full_trace] = bool
      end

      opts.separator "\nFlickr access options:"

      desc = "Flickr API key"
      opts.on("--flickr-api-key KEY", /[0-9a-f]+/, desc) do |text|
        options[:flickr_api_key] = text
      end

      desc = "Flickr API secret"
      opts.on("--flickr-api-secret SECRET", /[0-9a-f]+/, desc) do |text|
        options[:flickr_api_secret] = text
      end

      opts.separator "\nCommon options:"

      opts.on_tail("-h", "--help", "Show this message") do
        puts opts # Print out help summary.
        exit
      end

    end

    opt_parser.parse!(args)

    if options[:output_filename].nil?
      fail OptionParser::MissingArgument, "Output filename is not specified"
    end

    FileUtils.touch(options[:output_filename]) # Provoke IO error if file is not writeable.

    if options[:number_of_rows] > options[:number_of_images]
      fail StandardError, "Please set --total to #{options[:number_of_rows]} or greater value"
    end

    options
  end

end; end
