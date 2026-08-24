require "sinatra"
require "json"
require "time"
require "net/http"
require "socket"

QA_RELEASE = "A"
QA_READY_AFTER_SECONDS = 3
QA_NEVER_READY = false
QA_BOOTED_AT = Time.now.utc

# Configure Sinatra
set :port, ENV["PORT"] || 3000
set :bind, "0.0.0.0"
set :public_folder, "public"

# https://github.com/sinatra/sinatra/issues/2065
# disable it for all environments
set :host_authorization, { permitted_hosts: [] }

helpers do
  def qa_ready?
    !QA_NEVER_READY && (Time.now.utc - QA_BOOTED_AT) >= QA_READY_AFTER_SECONDS
  end

  def qa_response
    {
      release: QA_RELEASE,
      ready: qa_ready?,
      served_at: Time.now.utc.iso8601(6),
      booted_at: QA_BOOTED_AT.iso8601(6),
      replica: Socket.gethostname
    }
  end
end

before do
  headers "X-QA-Release" => QA_RELEASE
end

get "/ready" do
  content_type :json
  status qa_ready? ? 200 : 503
  qa_response.to_json
end

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
  content_type :json
  qa_response.to_json
end
