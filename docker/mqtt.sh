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

DISCOVERY_TOPIC_PREFIX="homeassistant/sensor"
STATE_TOPIC="orb_homeassistant/status"

# Publish MQTT Discovery message once (retained)
mapping="
Score|orb_score.display|%
Bandwidth Score|orb_score.components.bandwidth_score.display|%
Bandwidth Upload|orb_score.components.bandwidth_score.components.upload_bandwidth_kbps.value|kbps
Bandwidth Download|orb_score.components.bandwidth_score.components.download_bandwidth_kbps.value|kbps
Reliability Score|orb_score.components.reliability_score.display|%
Lag|orb_score.components.responsiveness_score.components.internet_lag_us.value|us
Packet Loss|orb_score.components.reliability_score.components.internet_loss_status.value|
Responsiveness Score|orb_score.components.responsiveness_score.display|%
"

echo "$mapping" | while IFS='|' read name field unit; do
  # Skip empty lines
  [ -z "$name" ] && continue

  unique_id=$(echo "$name" | tr '[:upper:]' '[:lower:]' | sed 's/ /_/g')
  DISCOVERY_TOPIC="${DISCOVERY_TOPIC_PREFIX}/orb_${unique_id}/config"
  

  payload=$(cat <<EOF
{
  "name": "${name}",
  "state_topic": "orb_homeassistant/status",
  "unit_of_measurement": "${unit}",
  "value_template": "{{ value_json.${field} | round(0) }}",
  "unique_id": "${unique_id}",
  "device": {
    "identifiers": ["orb"],
    "name": "Orb Sensor",
    "manufacturer": "Orb Forge",
    "model": "Orb Agent"
  }
}
EOF
)

  mosquitto_pub -h "$MQTT_HOST" -p "$MQTT_PORT" -u "$MQTT_USER" -P "$MQTT_PASS" \
    -t "$DISCOVERY_TOPIC" \
    -m "$payload" \
    -r 
done


# Periodic state updates
while true; do
  # Replace this with your real data source
  ORB_OUTPUT="$(/app/orb summary || echo '{}')"
  echo "ORB_OUTPUT: $ORB_OUTPUT"

  # Publish Orb Summary to MQTT
  mosquitto_pub -h "$MQTT_HOST" -p "$MQTT_PORT" -u "$MQTT_USER" -P "$MQTT_PASS" \
    -t "$STATE_TOPIC" -m "$ORB_OUTPUT" -r

  sleep 5
done