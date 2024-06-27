require 'httparty'
require 'open-uri'
require 'zlib'

class SeedDataService
  include HTTParty
  base_uri 'https://developer.nps.gov/api/v1'

  def initialize
    @nps_api_key = 'UrOCrJhmXlpq2Z4DrNsQ5XenBouBtA2Lnr2Y8wHl'
    @weather_api_key = 'b597d8858b8f2bbfa2970475cc9c3499'
    @mapbox_api_key = 'pk.eyJ1IjoiZ2RpYXoyIiwiYSI6ImNseHNlOTc1dDB3azIyam9teHZ6bGM3ajUifQ.I_4e-6FtDacppoo2j2qytg'
  end

  def fetch_parks
    topics = ['Waterfalls', 'Wetlands', 'Glaciers', 'Forest and Woodlands']
    activities = ['Arts and Culture', 'Astronomy', 'Camping', 'Boating']

    topics.each { |topic| fetch_parks_by_topic(topic) }
    activities.each { |activity| fetch_parks_by_activity(activity) }
  end

  def fetch_parks_by_topic(topic)
    response = nil
    retries ||= 0
    begin
      response = self.class.get("/parks", query: { api_key: @nps_api_key, q: topic, limit: 30 })
    rescue SocketError => e
      puts "Network error while trying to fetch parks by topic: #{topic}, error: #{e.message}"
      retries += 1
      if retries < 5
        sleep 2
        retry
      else
        puts "Failed to fetch parks by topic after 5 retries, skipping."
        return
      end
    end
    process_parks_response(response, :topic, topic) if response
  end

  def fetch_parks_by_activity(activity)
    response = nil
    retries ||= 0
    begin
      response = self.class.get("/parks", query: { api_key: @nps_api_key, q: activity, limit: 30 })
    rescue SocketError => e
      puts "Network error while trying to fetch parks by activity: #{activity}, error: #{e.message}"
      retries += 1
      if retries < 5
        sleep 2
        retry
      else
        puts "Failed to fetch parks by activity after 5 retries, skipping."
        return
      end
    end
    process_parks_response(response, :activity, activity) if response
  end

  def process_parks_response(response, type, name)
    if response.success?
      response.parsed_response['data'].each do |park_data|
        latitude = park_data['latitude']
        longitude = park_data['longitude']
        if latitude.present? && longitude.present?
          park = Park.find_or_create_by!(name: park_data['fullName']) do |p|
            p.description = park_data['description']
            p.location = "#{latitude}, #{longitude}"
            p.latitude = latitude
            p.longitude = longitude
            p.park_code = park_data['parkCode']
            p.states = park_data['states']
            p.full_state_names = park_data['states'].split(',').map { |abbr| Park.state_full_name(abbr) }.join(', ')
          end

          # Ensure multiple images per park
          park_data['images'].each do |image_data|
            image = park.images.find_or_create_by!(url: image_data['url'], source: 'NPS')
            attach_image(image, image_data['url'])
          end

          # Add multiple weather entries per park
          3.times do
            fetch_weather(park)
          end

          # Ensure map is created for each park
          fetch_map(park)

          # Associate the park with the activity or topic
          if type == :topic
            topic = Topic.find_or_create_by!(name: name)
            ParkTopic.find_or_create_by!(park: park, topic: topic)
          else
            activity = Activity.find_or_create_by!(name: name)
            ParkActivity.find_or_create_by!(park: park, activity: activity)
          end
        else
          puts "Latitude or longitude missing for park: #{park_data['fullName']}"
        end
      end
    else
      puts "Failed to fetch parks data for #{type}: #{name}, response code: #{response.code}"
    end
  end

  def attach_image(image, url)
    return if image.photo.attached?

    begin
      file = URI.open(url)
      image.photo.attach(io: file, filename: File.basename(url))
      image.save!
    rescue OpenURI::HTTPError => e
      puts "Failed to attach image from URL: #{url}, error: #{e.message}"
    rescue SocketError => e
      puts "Network error while trying to attach image from URL: #{url}, error: #{e.message}"
    rescue Zlib::BufError => e
      puts "Buffer error while trying to attach image from URL: #{url}, error: #{e.message}"
    rescue StandardError => e
      puts "General error while trying to attach image from URL: #{url}, error: #{e.message}"
    end
  end

  def fetch_weather(park)
    lat = park.latitude
    lon = park.longitude
    retries ||= 0
    begin
      weather_response = HTTParty.get("http://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{lon}&appid=#{@weather_api_key}&units=metric")

      if weather_response.success?
        weather_data = weather_response.parsed_response
        if weather_data['main'] && weather_data['weather']
          park.weathers.find_or_create_by!(date: Date.today) do |weather|
            weather.temperature = weather_data['main']['temp']
            weather.conditions = weather_data['weather'].first['description']
          end
        else
          puts "Weather data is missing expected keys: #{weather_data}"
        end
      else
        puts "Failed to fetch weather data for park: #{park.name}, response code: #{weather_response.code}"
      end
    rescue SocketError => e
      puts "Network error while trying to fetch weather data for park: #{park.name}, error: #{e.message}"
      retries += 1
      if retries < 5
        sleep 2
        retry
      else
        puts "Failed to fetch weather data after 5 retries, skipping."
      end
    rescue StandardError => e
      puts "General error while trying to fetch weather data for park: #{park.name}, error: #{e.message}"
    end
  end

  def fetch_map(park)
    retries ||= 0
    begin
      park.create_map!(
        map_url: "https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/#{park.longitude},#{park.latitude},10/600x600?access_token=#{@mapbox_api_key}",
        latitude: park.latitude,
        longitude: park.longitude
      )
    rescue ActiveRecord::StatementInvalid => e
      if e.message.include?('database is locked')
        puts "Database is locked, retrying..."
        retries += 1
        if retries < 5
          sleep 1
          retry
        else
          puts "Failed to create map after 5 retries, skipping."
        end
      else
        raise e
      end
    end
  end

  def seed_all
    fetch_parks
  end
end
