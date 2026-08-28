FROM ruby:3.4-slim

RUN apt-get update \
    && apt-get install --yes --no-install-recommends build-essential curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

ENV PORT=3000
EXPOSE 3000

CMD ["sh", "-c", "bundle exec puma -b \"tcp://[::]:${PORT:-3000}\" -e production"]
