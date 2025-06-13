# Add this to config.ru to log the incoming host
#   use RequestLogger
# See comment in config.ru
class RequestLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    puts "Incoming host (middleware): #{request.host}"
    @app.call(env)
  end
end