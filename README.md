# Orb

Home Assistant add-on for Orb.

## Overview

This add-on runs an [Orb](https://www.orb.net) sensor in your Home Assistant environment. Doing so allows you to monitor the network responsiveness and reliability of your Home Assistant instance from your mobile device or computer from anywhere in the world. You may choose to receive a push notification on your Android or iOS device any time your Home Assistant instance cannot reach the network or experiences deterioriated connectivity.

## Installation

1. Navigate to the Home Assistant Add-on Store
2. Add this repository URL to your add-on repositories
3. Find the "Orb" add-on in the store
4. Click Install
5. Enable auto-updates.

## Configuration

This add-on doesn't require any configuration. It automatically connects to your Orb devices on the network.

## Data Storage

The add-on stores its data in `/root/.config/orb` which is configured as persistent storage.

## Architecture Support

This add-on supports multiple architectures (aarch64, amd64, armv7).
