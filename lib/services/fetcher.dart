import 'dart:isolate';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void fetcher(SendPort sendPort) async {
  final url = Uri.https(
    "api.coingecko.com",
    "/api/v3/simple/price",
    {
      'ids': 'bitcoin,ethereum',
      'vs_currencies': 'jpy',
      'include_last_updated_at': 'true'
    },
  );
  while (true) {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var btcJpy = jsonResponse["bitcoin"]?["jpy"] as int?;
      var ethJpy = jsonResponse["ethereum"]?["jpy"] as int?;
      var result = (btcJpy != null && ethJpy != null)
          ? {'BTC': btcJpy, 'ETH': ethJpy}
          : {'error': 'could not parse price data'};
      sendPort.send(result);
    } else {
      print(response.toString());
      sendPort.send(
        {'error': 'request failed ${response.statusCode}'},
      );
    }
    await Future.delayed(Duration(seconds: 5));
  }
}
