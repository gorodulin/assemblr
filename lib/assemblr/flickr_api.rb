
require "open-uri"
require "pathname"

class Assemblr; class FlickrApi


  def initialize(api_key:, api_secret:)
    FlickRaw.api_key = api_key
    FlickRaw.shared_secret = api_secret
  end


  def download(url:, to:)
    ::File.open(to, "wb") do |local_file|
      open(url, "rb") do |remote_file|
        local_file.write(remote_file.read)
      end
    end
  end


  def find_by_text(text)
    text = text.to_s.downcase.strip.gsub(/\s+/, " ")
    tags = text.split(" ").join(",") # Comma-separated keywords
    underscore = ->(text) { text.tr(" ", "_") }
    response = flickr.photos.search(
      text: text,
      tags: tags,
      sort: "interestingness-desc",
      content_type: 1,   # Photos only
      privacy_filter: 1, # Public only
      per_page: 1,
    )
    response.first
  end


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

