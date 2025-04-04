ARG BUILD_FROM=ghcr.io/home-assistant/aarch64-base:3.16

FROM ${BUILD_FROM}

# Download and install Orb package - Will need to be able 
# to support multiple architectures when available
RUN wget -O /tmp/orb.apk https://ds.orb.net/orb_0.12.9_aarch64.apk && \
    apk add --no-scripts --allow-untrusted /tmp/orb.apk

# Copy run script
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
