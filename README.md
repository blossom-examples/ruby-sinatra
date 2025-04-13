# Ruby Sinatra Tutorial Deploy on Blossom

A ready-to-deploy Ruby Sinatra app to get you started quickly on [Blossom](https://blossom-cloud.com).

## Quick Start

```bash
# Install dependencies
bundle install

# Run the app
bundle exec puma
```

Visit `http://localhost:9292` in your browser to see the demo application.

### Environment Variables

- `PORT`: Change the port (default: 3000)

### API Endpoints

```bash
# Get a greeting
curl http://localhost:3000/api/hello?name=John

# Get a dad joke
curl http://localhost:3000/api/joke
```
