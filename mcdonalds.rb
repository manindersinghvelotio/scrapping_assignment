require 'net/http'
require 'json'

def fetch_mcdonalds_locations(latitude, longitude, radius, max_results)
  url = URI("https://www.mcdonalds.com/googleappsv2/geolocation?latitude=#{latitude}&longitude=#{longitude}&radius=#{radius}&maxResults=#{max_results}&country=us&language=en-us")

  response = Net::HTTP.start(url.host, url.port, use_ssl: url.scheme == 'https') do |http|
    request = Net::HTTP::Get.new(url)
    request['Content-Type'] = 'application/json'
    request['User-Agent'] = 'PostmanRuntime/7.37.3'
    http.request(request)
  end

  handle_response(response)
rescue StandardError => e
  puts "An error occurred: #{e.message}"
end

def handle_response(response)
  if response.is_a?(Net::HTTPSuccess)
    data = JSON.parse(response.body)
    print_locations(data)
  else
    puts "HTTP request failed: #{response.code} - #{response.message}"
  end
end

def print_locations(data)
  data["features"].each do |outlet|
    puts "Name: #{outlet["properties"]["shortDescription"]}"
    puts "Phone: #{outlet["properties"]["telephone"]}"
    puts "Address: #{outlet["properties"]["customAddress"]}"
    puts "Latitude: #{outlet["geometry"]["coordinates"][0]}"
    puts "Longitude: #{outlet["geometry"]["coordinates"][1]}"
    puts "\n"
  end
end

# Example usage
fetch_mcdonalds_locations(39.7392358, -104.990251, 8.045, 5)
