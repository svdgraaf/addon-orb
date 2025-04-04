#!/usr/bin/env bashio

bashio::log.info "Starting Orb addon..."

# Create persistent data directory if it doesn't exist
DATA_DIR=/config/orb_data
mkdir -p ${DATA_DIR}
bashio::log.info "Persistent data directory created at ${DATA_DIR}"

# Set the ORB_DATA_DIR environment variable
export ORB_DATA_DIR=${DATA_DIR}
bashio::log.info "ORB_DATA_DIR set to ${ORB_DATA_DIR}"

# Run orb service
bashio::log.info "Starting orb service..."
exec orb service
