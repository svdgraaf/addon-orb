#!/bin/sh

# Start MQTT publishing in the background
/run.sh &

# Now start the original entrypoint or command
exec "$@"