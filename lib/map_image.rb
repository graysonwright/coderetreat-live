require 'httparty'

class MapImage
  def self.for(location)
    new(location).image_path
  end

  def initialize(location)
    @location = location
    fetch_image_unless_cached
  end

  def image_path
    if File.exist? cache_path
      cache_path
    else
      default_image_path
    end
  end

  protected
  def fetch_image_unless_cached
    unless File.exist? cache_path
      fetch_image
    end
  end

  def fetch_image
    response = HTTParty.get(request_url)

    if response.code == 200
      write_image response.body
    end
  end

  def write_image contents
    FileUtils.mkdir_p(image_root)
    File.open(cache_path, "wb") do |f|
      f.write(contents)
    end
  end

  def image_root
    "public/map_images"
  end

  def cache_path
    File.join(image_root, "#{@location}.png")
  end

  def default_image_path
    File.join(image_root, "default.png")
  end

  def request_url
    "https://maps.googleapis.com/maps/api/staticmap?#{request_parameter_string}"
  end

  def request_parameter_string
    request_parameters.join("&")
  end

  def request_parameters
    [
      "markers=#{@location}",
      "size=100x100",
      "style=feature:all%7Celement:labels%7Cvisibility:off",
      "zoom=1",
    ]
  end
end