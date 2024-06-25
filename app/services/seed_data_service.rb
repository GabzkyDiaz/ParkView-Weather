require 'httparty'

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
    response = self.class.get("/parks", query: { api_key: @nps_api_key, q: topic, limit: 30 })
    process_parks_response(response, :topic, topic)
  end

  def fetch_parks_by_activity(activity)
    response = self.class.get("/parks", query: { api_key: @nps_api_key, q: activity, limit: 30 })
    process_parks_response(response, :activity, activity)
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
          end

          # Ensure multiple images per park
          park_data['images'].each do |image_data|
            park.images.find_or_create_by!(url: image_data['url'], source: 'NPS')
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

  def fetch_weather(park)
    lat = park.latitude
    lon = park.longitude
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
  end

  def fetch_map(park)
    park.create_map!(
      map_url: "https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/#{park.longitude},#{park.latitude},10/600x600?access_token=#{@mapbox_api_key}",
      latitude: park.latitude,
      longitude: park.longitude
    )
  end

  def seed_all
    fetch_parks
  end
end
