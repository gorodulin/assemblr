
require "open-uri"
require "pathname"

#
# Project-specific Flickr related methods.
#
class Assemblr; class FlickrApi


  # @param [String] api_key
  # @param [String] api_secret
  def initialize(api_key:, api_secret:)
    ::FlickRaw.api_key = api_key
    ::FlickRaw.shared_secret = api_secret
  end


  # Download image and save it to a local file.
  # @param [String] url URL
  # @param [String] to File path
  def download(url:, to:)
    ::File.open(to, "wb") do |local_file|
      open(url, "rb") do |remote_file|
        local_file.write(remote_file.read)
      end
    end
  end


  # Find image by a keyword.
  #
  # @param [String] text Keyword or keywords. String can contain spaces.
  # @return [Hash] Various details about image found.
  def find_by_text(text)
    text = text.to_s.downcase.strip.gsub(/\s+/, " ")
    tags = text.split(" ").join(",") # Comma-separated keywords.
    underscore = ->(text) { text.tr(" ", "_") }
    response = flickr.photos.search(
      text: text,
      tags: tags,
      tag_mode: "all",
      license: "1,2,3,4,5,6,7,8", # @see https://www.flickr.com/services/api/flickr.photos.licenses.getInfo.html
      sort: "interestingness-desc",
      content_type: 1,   # Photos only.
      privacy_filter: 1, # Public only.
      per_page: 1,
    )
    response.first
  end


  # Every image on Flickr is stored in various sizes.
  # This method chooses the closest to <tt>min_height</tt>
  # @return [Hash] image details.
  # @return [nil] if no applicable size found.
  def size_for(image, min_height:)
    image_sizes  = flickr.photos.getSizes(photo_id: image.id)
    perfect_size = image_sizes.detect{ |size| size.height.to_i > min_height} # TODO: replace to max_by
    return nil unless perfect_size
    {
      id: image.id,
      url: perfect_size.source,
      height: perfect_size.height.to_i,
      width:  perfect_size.width.to_i,
    }
  rescue FlickRaw::FailedResponse
    nil
  end


end; end

