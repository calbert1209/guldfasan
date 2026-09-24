import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:html/parser.dart' as html_parser;

class FetchedMessage {
  FetchedMessage({this.sendPort, this.prices, this.error});
  final SendPort? sendPort;
  final Map<String, int>? prices;
  final String? error;

  bool hasSendPort() => this.sendPort != null;
  bool hasPrices() => this.prices != null;
  bool hasError() => this.error != null;
}

Future<http.Response> _fetchCoinData() {
  final url = Uri.https(
    "api.coingecko.com",
    "/api/v3/simple/price",
    {
      'ids': 'bitcoin,ethereum',
      'vs_currencies': 'jpy',
      'include_last_updated_at': 'true'
    },
  );
  return http.get(url);
}

const _goldCacheTtl = Duration(minutes: 30);
Map<String, int?>? _goldPricesCache;
DateTime? _goldPricesCacheFetchedAt;

Future<Map<String, int?>> _fetchGoldData() async {
  final now = DateTime.now();
  final hasValidCache = _goldPricesCache != null &&
      _goldPricesCacheFetchedAt != null &&
      now.difference(_goldPricesCacheFetchedAt!) < _goldCacheTtl;

  if (hasValidCache) {
    return _goldPricesCache!;
  }

  final url = Uri.https(
    "gold.tanaka.co.jp",
    "/commodity/souba/index.php",
  );
  final response = await http.get(url);
  if (response.statusCode != 200) {
    throw StateError('gold request failed ${response.statusCode}');
  }

  final parsed = parseGoldPrices(response.body);
  _goldPricesCache = parsed;
  _goldPricesCacheFetchedAt = now;
  return parsed;
}

@visibleForTesting
Map<String, int?> parseGoldPrices(String body) {
  final doc = html_parser.parse(body);
  final goldRow = doc.querySelector('#metal_price tr.gold');
  if (goldRow == null) {
    throw StateError('gold row not found');
  }

  String clean(String? s) => (s ?? '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .replaceAll(",", "")
      .replaceAll(" 円", "")
      .trim();

  final retailStr =
      clean(goldRow.querySelector('td.retail_tax')?.text); // 29755
  final buyStr = clean(goldRow.querySelector('td.purchase_tax')?.text); // 29398

  return {
    'retail': int.tryParse(retailStr),
    'buy': int.tryParse(buyStr),
  };
}

@visibleForTesting
Map<String, int?> parseCoinPrices(String body) {
  var jsonResponse = convert.jsonDecode(body) as Map<String, dynamic>;
  var btcJpy = jsonResponse["bitcoin"]?["jpy"] as int?;
  var ethJpy = jsonResponse["ethereum"]?["jpy"] as int?;
  return {
    'BTC': btcJpy,
    'ETH': ethJpy,
  };
}

void fetcher(SendPort toParent) async {
  final fromParent = ReceivePort();
  toParent.send(FetchedMessage(sendPort: fromParent.sendPort));

  var duration = Duration(seconds: 30);

  var executeFetch = () async {
    try {
      var response = await _fetchCoinData();
      var goldPrices = await _fetchGoldData();

      if (response.statusCode == 200) {
        var coinPrices = parseCoinPrices(response.body);
        var btcJpy = coinPrices['BTC'];
        var ethJpy = coinPrices['ETH'];
        var xauJpy = goldPrices['buy'];
        var result = (btcJpy != null && ethJpy != null && xauJpy != null)
            ? FetchedMessage(
                sendPort: fromParent.sendPort,
                prices: {'BTC': btcJpy, 'ETH': ethJpy, 'XAU': xauJpy},
              )
            : FetchedMessage(
                sendPort: fromParent.sendPort,
                error: 'could not parse price data',
              );
        toParent.send(result);
      } else {
        print(response.toString());
        toParent.send(
          FetchedMessage(
              sendPort: fromParent.sendPort,
              error: 'request failed ${response.statusCode}'),
        );
      }
    } catch (e) {
      toParent.send(
        FetchedMessage(
          sendPort: fromParent.sendPort,
          error: e.toString(),
        ),
      );
    }
  };

  fromParent.listen((message) {
    if (message is Duration) {
      print('fetcher got msg: $message');
      duration = message;
    } else if (message == "immediate") {
      print("immediate fetch requested");
      executeFetch();
    }
  });

  await executeFetch();

  while (true) {
    await Future.delayed(duration, executeFetch);
  }
}
