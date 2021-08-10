import 'dart:async';
import 'dart:isolate';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

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

void fetcher(SendPort toParent) async {
  final fromParent = ReceivePort();
  toParent.send(FetchedMessage(sendPort: fromParent.sendPort));

  var duration = Duration(milliseconds: 500);

  var executeFetch = () async {
    try {
      var response = await _fetchCoinData();
      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        var btcJpy = jsonResponse["bitcoin"]?["jpy"] as int?;
        var ethJpy = jsonResponse["ethereum"]?["jpy"] as int?;
        var result = (btcJpy != null && ethJpy != null)
            ? FetchedMessage(
                sendPort: fromParent.sendPort,
                prices: {'BTC': btcJpy, 'ETH': ethJpy},
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
