Weather = Struct.new(
    :sunrise, :solar_noon, :sunset,
    :moon_phase, :moonrise, :moonset,
)

ThelemicDate = Struct.new(
    :sol, :luna, :year
)

class String
    def titlecase
        self.split(' ').map(&:capitalize).join(' ')
    end
end

def get_geo_astronomy(ip = nil)
    ip = nil if BAD_IPS.include?(ip)
    api_key = $env.data.dig('ipgeolocation', 'api_key')
    uri = 'https://api.ipgeolocation.io/astronomy'
    return simple_get_body(uri, { 'apiKey' => api_key })
end

def get_lat_lon(ip = nil, astronomy = nil)
    astronomy = get_geo_astronomy(ip) unless astronomy
    lat = astronomy.dig('location', 'latitude')
    lon = astronomy.dig('location', 'longitude')
    return [lat, lon]
end

def get_pirate_weather(lat, lon)
    api_key = $env.data.dig('pirate_weather', 'api_key')
    uri = "https://api.pirateweather.net/forecast/#{api_key}/#{lat},#{lon}"
    return simple_get_body(uri)
end

def get_weather(ip = nil)
    astronomy = get_geo_astronomy(ip)
    return Weather.new(
        astronomy.dig('sunrise'),
        astronomy.dig('solar_noon'),
        astronomy.dig('sunset'),
        astronomy.dig('moon_phase').gsub('_', ' ').titlecase,
        astronomy.dig('moonrise'),
        astronomy.dig('moonset'),
    )
end

def get_thelemic_date
    uri "https://machin.dev/api/thelemic_date.json"
    response = simple_get_body(uri)
    return ThelemicDate.new(
        response.dig('plain', 'sol'),
        response.dig('plain', 'luna'),
        response.dig('plain', 'year_alt'),
    )
end

get '/api/weather.json' do
    weather = get_weather(get_ip)
    content_type 'application/json'
    {
        sunrise: weather.sunrise,
        solar_noon: weather.solar_noon,
        sunset: weather.sunset,
        moon_phase: weather.moon_phase,
        moonrise: weather.moonrise,
        moonset: weather.moonset,
    }.to_json
end
