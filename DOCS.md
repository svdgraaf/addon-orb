# Orb

## Overview

This add-on runs an [Orb](https://www.orb.net) sensor in your Home Assistant environment. Doing so allows you to monitor the network responsiveness and reliability of your Home Assistant instance from your mobile device or computer from anywhere in the world. You may choose to receive a push notification on your Android or iOS device any time your Home Assistant instance cannot reach the network or experiences deterioriated connectivity.

## Installation

Follow these steps to install the add-on:

1. Navigate to the Home Assistant Add-on Store
2. Add this repository URL to your add-on repositories
3. Find the "Orb" add-on in the store
4. Click Install
5. Enable auto-updates.

## How to use

1. Start the add-on
2. Open the [Orb](https://www.orb.net) app while connected to the same network as Home Assistant
3. The Orb app will automatically detect your Home Assistant Orb sensor

## Configuration

This add-on doesn't require any configuration. It uses the following settings:

- Host network: Enabled (required for device discovery)
- Persistent storage: Configured for /root/.config/orb

## Troubleshooting

If you encounter issues detecting the Orb sensor from the Orb app:

1. Confirm that Home Assistant and the device running the Orb app are on the same network
2. Restart the add-on
3. Check the add-on logs for any error messages

## Support

For support, please refer to the [Orb documentation](https://www.orb.net/docs).
