# Guldfasan Project Overview

## What is Guldfasan?
Guldfasan is a Flutter-based personal portfolio and investment tracking application. It currently tracks positions in cryptocurrencies (Bitcoin, Ethereum) and precious metals (Gold).

The app stores purchase histories locally and provides real-time portfolio valuation by dynamically fetching and scraping live market prices in the background.

## Key Features
* **Portfolio Tracking**: Users can track their asset positions (Units bought, Purchase Price, Date/Time).
* **Live Market Pricing**: Real-time asset prices are fetched periodically in the background (every 30 seconds by default).
* **Crypto API Integration**: Fetches BTC and ETH prices using the `api.coingecko.com` REST API.
* **Gold Web Scraping**: Scrapes Japanese retail and buy Gold prices from `gold.tanaka.co.jp` via HTTP and HTML parsing.
* **Local Persistence**: User portfolio data is saved using SQLite.

## Core Technologies & Dependencies
* **Framework**: Flutter (Dart)
* **State Management**: `provider`
* **Local Database**: `sqflite`
* **Networking/Scraping**: `http`, `html` (for DOM parsing)
* **UI/UX**: Material components (with custom fonts `Rajdhani` and `KoHo`).
* **Concurrency**: Dart `Isolate`s are used to run background price fetching independently from the main UI thread.

## Directory Structure
* `lib/models/`: Core domain models (`Position`, `PositionCollection`).
* `lib/services/`: Background tasks and local data access (`fetcher.dart`, `db.dart`).
* `lib/pages/`: Full screen routing targets (`home_page.dart`, `add_position_page.dart`, etc.).
* `lib/widgets/`: Reusable UI components.
* `lib/themes/`: Custom color palettes (`amber.dart`).
