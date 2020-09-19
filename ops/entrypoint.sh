#!/bin/bash -l
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /webapp/tmp/pids/server.pid

yarn install
bundle install
./bin/webpack
echo "Starting $@"
# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
