require "sinatra"
require "json"
require "time"

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

post "/api/echo" do
  content_type :json
  data = JSON.parse(request.body.read)
  {
    message: "Echo response",
    received: data,
    timestamp: Time.now.utc.iso8601
  }.to_json
end

# Serve static files
get "/" do
  send_file File.join(settings.public_folder, "index.html")
end

# Start the server
if __FILE__ == $0
  puts "Starting server..."
  puts "- Environment: #{settings.environment}"
  puts "- Port: #{settings.port}"
  puts "- URL: http://localhost:#{settings.port}"
  puts "\nReady! Visit http://localhost:#{settings.port} to see the demo"

  Thin::Server.start(app, Port: settings.port, Address: settings.bind)
end
