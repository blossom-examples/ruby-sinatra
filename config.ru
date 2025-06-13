require "./app"
require "./middleware/request_logger"

# use RequestLogger
run Sinatra::Application
