#!/bin/bash

echo "Creating database if it's not present..."
bin/rails db:create

echo "Migrating database..."
bin/rails db:migrate

# echo "Precompiling assets..."
# bin/rails assets:precompile

# If the container has been killed, there may be a stale pid file
# preventing rails from booting up
echo "Removing server.pid file..."
rm -f tmp/pids/server.pid && echo "done"

echo "Running $@ ..."
exec "$@"
