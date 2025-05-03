#!/usr/bin/with-contenv bashio

set -e

MQTT_HOST="${HASSIO_MQTT_HOST:-core-mosquitto}"
MQTT_PORT="${HASSIO_MQTT_PORT:-1883}"
MQTT_USER="$HASSIO_MQTT_USERNAME"
MQTT_PASS="$HASSIO_MQTT_PASSWORD"

DISCOVERY_TOPIC="homeassistant/sensor/orb_score/config"
STATE_TOPIC="orb_svdgraaf/status"

# Publish MQTT Discovery message once (retained)
mosquitto_pub -h "$MQTT_HOST" -p "$MQTT_PORT" -u "$MQTT_USER" -P "$MQTT_PASS" \
  -t "$DISCOVERY_TOPIC" \
  -m '{
    "name": "Orb Score",
    "state_topic": "orb_svdgraaf/status",
    "unit_of_measurement": "%",
    "value_template": "{{ value_json.display }}",
    "unique_id": "orb_score_sensor",
    "device": {
      "identifiers": ["orb"],
      "name": "Orb Sensor",
      "manufacturer": "Orb Forge",
      "model": "Orb Agent"
    }
  }' \
  -r

# Periodic state updates
while true; do
  # Replace this with your real data source
  ORB_OUTPUT="$(/app/orb summary || echo '{}')"

  # Publish Orb Summary to MQTT
  mosquitto_pub -h "$MQTT_HOST" -p "$MQTT_PORT" -u "$MQTT_USER" -P "$MQTT_PASS" \
    -t "$STATE_TOPIC" -m "$ORB_OUTPUT"

  sleep 30
done