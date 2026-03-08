# LinkyTracker

Track your French Linky electricity meter consumption with a self-hosted dashboard and iOS app.

## What LinkyTracker does

- Automatically fetches daily electricity consumption from your Linky meter
- Shows day-by-day consumption, load curves, and peak power usage
- Calculates costs based on your HC/HP (off-peak/peak) tariff
- Monthly trends and most expensive days
- iOS app with dashboard, trends, HC/HP breakdown, and settings
- Data syncs automatically every day

## Prerequisites

- A Linky smart meter installed at home
- An [Enedis](https://mon-compte-particulier.enedis.fr/) account (French electricity grid operator)
- Docker installed on your server
- Xcode (only if you want to build the iOS app)

## Getting your API keys

### Conso API token (to access your Linky data)

1. Go to [conso.boris.sh](https://conso.boris.sh)
2. Click the authorization button
3. Log in to your Enedis account and accept data sharing
4. Copy the token displayed at the end

### PRM number (your meter ID)

You can find it in one of these places:

- **On your Linky meter**: press the **+** button to scroll to the PRM number
- **On your electricity bill**: listed as "PRM" or "PDL" (Point de Livraison)
- **In your Enedis account**: visible in your online dashboard

### API token (to secure your server)

Choose any password you like — this protects access to your LinkyTracker server. The same token must be set on the server and in the iOS app.

### Sentry DSN (optional, for error tracking)

Create a free project at [sentry.io](https://sentry.io) if you want error tracking. Skip this if you don't need it.

## Installation — Server (Docker)

### Standard Docker

1. Copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```
2. Fill in the variables in `.env`:
   - `NITRO_CONSO_API_TOKEN` — your Conso API token
   - `NITRO_CONSO_API_PRM` — your PRM number
   - `NITRO_API_TOKEN` — the password you chose to secure your server
   - `NITRO_SENTRY_DSN` — your Sentry DSN (leave empty to skip)
3. Start the server:
   ```bash
   docker compose up -d
   ```
4. The server runs on port **3000**
5. Your data is stored in `./data/` (persisted via a Docker volume)

### CasaOS

1. Use the provided `docker-compose.casaos.yml`
2. Update the `image` field with your Docker image
3. Set the environment variables
4. Import the file in CasaOS

## Installation — iOS app

1. Open `ios/LinkyTracker.xcodeproj` in Xcode
2. Copy the secrets template:
   ```bash
   cp ios/LinkyTracker/Shared/Secrets.swift.example ios/LinkyTracker/Shared/Secrets.swift
   ```
3. Edit `Secrets.swift` and fill in your API token and Sentry DSN
4. Set your development team in Xcode (Signing & Capabilities)
5. Build and run on your device

## How it works

- The server fetches your Linky data automatically every day (around 10am and 11am UTC)
- Enedis data is available with a one-day delay — yesterday's data appears around 8am
- Configure your HC/HP rates from the app settings
- All data is stored locally on your server — nothing goes to the cloud
