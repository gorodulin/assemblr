
class Assemblr; class Default

  # Default options for the app.
  # @see the source code of the method.
  def self.options
    {
      dictionary_file: "/usr/share/dict/words",
      flickr_api_key:  ENV["FLICKR_API_KEY"],
      flickr_api_secret: ENV["FLICKR_API_SECRET"],
      is_adjust8px: false,
      is_full_trace: false,
      is_verbose: true,
      keywords: [],
      number_of_images: 10,
      number_of_rows: 3,
      output_filename: nil,
      output_quality: 90,
      row_height_px: 296,
      temp_dir: nil,
    }
  end

end; end

