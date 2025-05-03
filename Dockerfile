FROM orbforge/orb:latest

# Install mosquitto_pub/sub via system package manager
RUN apk add --no-cache mosquitto-clients

# Add scripts
COPY run.sh /run.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /run.sh /entrypoint.sh

# Override the entrypoint to inject the background script
ENTRYPOINT ["/entrypoint.sh"]