# Ruby Sinatra Tutorial Deploy on Blossom

[![Blossom Badge](https://img.boltops.com/images/blossom/logos/blossom-readme.png)](https://blossom-cloud.com)

A ready-to-deploy Ruby Sinatra app to get you started quickly on [Blossom](https://blossom-cloud.com).

## Quick Start

```bash
# Install dependencies
bundle install

# Run the app
bundle exec puma
```

Visit `http://localhost:9292` in your browser to see the demo application.

### API Endpoints

```bash
# Get a greeting
curl http://localhost:3000/api/hello?name=John

# Get a dad joke
curl http://localhost:3000/api/joke
```
