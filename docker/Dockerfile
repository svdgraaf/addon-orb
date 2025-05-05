FROM orbforge/orb:latest

# Install mosquitto_pub/sub via system package manager
RUN apk add --no-cache mosquitto-clients

# Add scripts
COPY mqtt.sh /mqtt.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /mqtt.sh /entrypoint.sh

# Override the entrypoint to inject the background script
ENTRYPOINT ["/entrypoint.sh"]