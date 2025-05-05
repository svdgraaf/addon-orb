#!/bin/sh

set -x

AUTH_HEADER="Authorization: Bearer ${SUPERVISOR_TOKEN}"
MQTT_INFO=$(curl -s -H "$AUTH_HEADER" http://supervisor/services/mqtt)

MQTT_HOST=$(echo "$MQTT_INFO" | jq -r '.data.host')
MQTT_PORT=$(echo "$MQTT_INFO" | jq -r '.data.port')
MQTT_USER=$(echo "$MQTT_INFO" | jq -r '.data.username')
MQTT_PASS=$(echo "$MQTT_INFO" | jq -r '.data.password')

echo "MQTT Host: $MQTT_HOST"
echo "MQTT Port: $MQTT_PORT"
echo "MQTT User: $MQTT_USER"

DISCOVERY_TOPIC="homeassistant/sensor/orb/config"
STATE_TOPIC="orb/status"

# Publish MQTT Discovery message once (retained)
mosquitto_pub -h "$MQTT_HOST" -p "$MQTT_PORT" -u "$MQTT_USER" -P "$MQTT_PASS" \
  -t "$DISCOVERY_TOPIC" \
  -m '{
    "name": "Orb Score",
    "state_topic": "orb/status",
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
  echo "ORB_OUTPUT: $ORB_OUTPUT"

  # Publish Orb Summary to MQTT
  mosquitto_pub -h "$MQTT_HOST" -p "$MQTT_PORT" -u "$MQTT_USER" -P "$MQTT_PASS" \
    -t "$STATE_TOPIC" -m "$ORB_OUTPUT"

  sleep 5
done