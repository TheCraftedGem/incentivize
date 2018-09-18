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

COPY priv/nodejs ./priv/nodejs

WORKDIR priv/nodejs
# Cache Node deps
RUN npm install

WORKDIR ../..

COPY assets ./assets

WORKDIR assets
# Cache Node deps
RUN npm install && npm run deploy

WORKDIR ..

# Add the files to the image
COPY . .

ENV PORT 5000

# Compile app and make release
RUN mix do compile, phx.digest, release

# Exposes this port from the docker container to the host machine
EXPOSE 5000

# The command to run when this image starts up
CMD ["_build/prod/rel/incentivize/bin/incentivize", "foreground"]
