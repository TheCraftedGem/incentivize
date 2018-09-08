# Set the Docker image you want to base your image off.
FROM elixir:1.7

# Add nodejs
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

# Install other stable dependencies that don't change often
RUN apt-get update && \
  apt-get install -y --no-install-recommends apt-utils postgresql-client nodejs

WORKDIR /opt/app

# Install and compile project dependencies
# We do this before all other files to make container build faster
# when configuration and dependencies are not changed
COPY mix.* ./
COPY config/* ./config/

ENV MIX_ENV prod

RUN mix do local.rebar --force, local.hex --force, deps.get --only prod, deps.compile

COPY nodejs ./nodejs

WORKDIR nodejs
# Cache Node deps
RUN npm install

WORKDIR ..

COPY assets ./assets

WORKDIR assets
# Cache Node deps
RUN npm install && npm run deploy

WORKDIR ..

# Add the files to the image
COPY . .

ENV PORT 5000

# Compile app
RUN mix do compile, phx.digest

# Exposes this port from the docker container to the host machine
EXPOSE 5000

# Run server
CMD ["mix", "phx.server", "--no-deps-check", "--no-compile", "--no-halt"]
