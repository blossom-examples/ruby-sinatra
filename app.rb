require "sinatra"
require "json"
require "time"
require "net/http"

STARTED_AT = Time.now.utc

def readiness
  delay = Float(ENV.fetch("READY_DELAY_SECONDS", "0"))
  ready_at = STARTED_AT + delay
  ready = ENV.fetch("READY_MODE", "pass") == "pass" && Time.now.utc >= ready_at
  [ready, ready_at]
rescue ArgumentError
  halt 500, {error: "READY_DELAY_SECONDS must be numeric"}.to_json
end

def qualification_payload
  ready, ready_at = readiness
  {
    release_id: ENV.fetch("RELEASE_ID", "unknown"),
    instance: ENV.fetch("HOSTNAME", "unknown"),
    started_at: STARTED_AT.iso8601(6),
    ready_at: ready_at.iso8601(6),
    request_at: Time.now.utc.iso8601(6),
    ready: ready
  }
end

# Configure Sinatra
set :port, ENV["PORT"] || 3000
set :bind, ENV.fetch("BIND_ADDRESS", "::")
set :public_folder, "public"

# https://github.com/sinatra/sinatra/issues/2065
# disable it for all environments
set :host_authorization, { permitted_hosts: [] }

# API Routes
get "/qa" do
  content_type :json
  headers "X-Blossom-Fixture-Release" => ENV.fetch("RELEASE_ID", "unknown")
  qualification_payload.to_json
end

get "/ready" do
  content_type :json
  payload = qualification_payload
  status 503 unless payload.fetch(:ready)
  payload.to_json
end

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
