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

### Deployment Qualification Endpoints

`GET /qa` returns the serving release and instance identity. `GET /ready`
returns `503` until its configured delay passes, or indefinitely when readiness
is intentionally failed:

```bash
RELEASE_ID=B READY_DELAY_SECONDS=6 bundle exec puma
RELEASE_ID=C READY_MODE=fail bundle exec puma
curl http://localhost:3000/qa
curl http://localhost:3000/ready
```

The fixture has no external side effects. Use `/qa` for a continuous public
request stream and `/ready` for both the Container and reverse-proxy readiness
checks.
