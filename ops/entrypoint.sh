#!/bin/bash -l
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /webapp/tmp/pids/server.pid

bundle install
./bin/webpack

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
