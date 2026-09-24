# Architecture & Data Flow

## State Management
Guldfasan uses a hybrid approach to state and data flow:
1. **`ChangeNotifierProvider` (Provider)**: Exposes `AppState` to the widget tree.
2. **Dart `Isolate` + `StreamController`**: The `AppState` bridges the UI and a background worker isolate using `SendPort` and `ReceivePort`.

## The `fetcher` Isolate
To prevent network latency and heavy HTML parsing from blocking the UI thread (jank), price fetching is offloaded to a separate Dart Isolate (`lib/services/fetcher.dart`).

1. **Spawning**: `main.dart` spawns the `fetcher` isolate upon startup and gives it a `ReceivePort.sendPort`.
2. **Polling loop**: Inside the isolate, an infinite loop fetches prices (CoinGecko API + Tanaka Gold Web Scraper) every 30 seconds.
3. **Communication**: When new prices are fetched, it sends a `FetchedMessage` back to the main isolate containing a Map of `prices` (e.g. `{'BTC': 5000000, 'ETH': 300000, 'XAU': 10000}`).
4. **UI Updates**: `AppState` listens to these messages and pumps them through a `StreamController.broadcast()`. The UI listens to this stream via `PortfolioStreamBuilder` to update live valuations.

## Local Database (`sqflite`)
Data persistence is handled by `DatabaseService` (`lib/services/db.dart`).
* **Table**: `position`
* **Schema**:
  * `_id` (Integer / Auto-increment)
  * `symbol` (Text) - Represents the asset (e.g., "BTC", "ETH").
  * `units` (Real) - The quantity of the asset held.
  * `price` (Real) - The purchase price.
  * `datetime` (Text) - Iso8601 string of the purchase date.

## The Model Layer
* **`Position`**: Represents a single historical purchase/trade.
* **`PositionCollection`**: Groups multiple `Position` instances by their `symbol` (e.g., grouping 5 different BTC purchases together) so the UI can calculate an aggregate average cost basis or total profit.