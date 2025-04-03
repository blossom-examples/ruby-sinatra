require "sinatra"
require "json"
require "time"
require "net/http"

# Configure Sinatra
set :port, ENV["PORT"] || 3000
set :bind, "0.0.0.0"
set :public_folder, "public"

# API Routes
get "/api/hello" do
  content_type :json
  name = params[:name] || "World"
  {
    message: "Hello, #{name}!",
    timestamp: Time.now.utc.iso8601
  }.to_json
end

get "/api/joke" do
  content_type :json
  begin
    uri = URI("https://icanhazdadjoke.com/")
    request = Net::HTTP::Get.new(uri)
    request["Accept"] = "application/json"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    joke_data = JSON.parse(response.body)
    {
      message: "Dad joke received!",
      joke: joke_data["joke"],
      timestamp: Time.now.utc.iso8601
    }.to_json
  rescue => e
    status 500
    {
      error: "Failed to fetch dad joke",
      message: e.message,
      timestamp: Time.now.utc.iso8601
    }.to_json
  end
end

# Serve static files
get "/" do
  send_file File.join(settings.public_folder, "index.html")
end
