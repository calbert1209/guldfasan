import 'dart:isolate';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/widgets/portfolio.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

final _formatDate = DateFormat("yyyy-MM-dd HH:mm:ss").format;

Future<void> updateIsolateDuration(SendPort sendPort) async {
  var type = await Connectivity().checkConnectivity();
  if (type == ConnectivityResult.wifi) {
    sendPort.send(Duration(seconds: 30));
  } else if (type == ConnectivityResult.mobile) {
    sendPort.send(Duration(seconds: 60));
  } else {
    sendPort.send(Duration(seconds: 120));
  }
}

bool snapshotHasSendPort(dynamic data) {
  return data is Map<String, dynamic> &&
      data.containsKey('port') &&
      data['port'] is SendPort;
}

class PortfolioStreamBuilder extends StatelessWidget {
  PortfolioStreamBuilder(this._portfolio);

  final Iterable<PositionCollection> _portfolio;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return StreamBuilder<dynamic>(
      stream: appState.stream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        Map<String, int> priceData = {"BTC": -1, "ETH": -1};
        var timestamp = "not updated!";
        if (snapshot.hasError) {
          print(snapshot.error);
        }
        if (snapshot.hasData && snapshot.data != null) {
          if (snapshot.data!.hasPrices()) {
            priceData = snapshot.data!.prices!;
          }
          timestamp = _formatDate(DateTime.now());
          if (snapshot.data!.hasSendPort()) {
            updateIsolateDuration(snapshot.data!.sendPort!);
          }
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                'last updated: $timestamp',
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  color: Colors.grey,
                ),
              ),
            ),
            Portfolio(_portfolio, priceData),
          ],
        );
      },
    );
  }
}
