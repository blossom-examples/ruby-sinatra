# Ruby Sinatra Tutorial Deploy on Blossom

[![Blossom Badge](https://img.boltops.com/images/blossom/logos/blossom-readme.png)](https://blossom-cloud.com)

A ready-to-deploy Ruby Sinatra app to get you started quickly on [Blossom](https://blossom-cloud.com).

Blossom's default **Auto** strategy builds this repository with Cloud Native
Buildpacks through `pack build`. Auto does not scan for a Dockerfile or switch
strategies based on repository contents.

The conventional root `Dockerfile` provides a second explicit path for testing
or selecting Blossom's **Dockerfile** strategy. The same application therefore
qualifies both builders without changing the default zero-configuration
experience.

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
