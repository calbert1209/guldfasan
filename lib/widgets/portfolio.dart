import 'dart:isolate';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:guldfasan/app_state.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/services/fetcher.dart';
import 'package:guldfasan/widgets/position_collection_display.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
    return StreamBuilder<FetchedMessage>(
      stream: appState.receivePort.cast<FetchedMessage>(),
      builder: (BuildContext context, AsyncSnapshot<FetchedMessage> snapshot) {
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

double reduceCollectionProfit(PositionCollection collection, int price) {
  return collection.positions.fold<double>(0, (prev, position) {
    final purchaseValue = position.units * position.price;
    final currentValue = position.units * price;
    return prev + currentValue - purchaseValue;
  });
}

double reduceTotalProfit(
  Iterable<PositionCollection> portfolio,
  Map<String, int> prices,
) {
  var total = 0.0;
  for (var collection in portfolio) {
    final currentPrice = prices[collection.symbol]!;
    final profit = reduceCollectionProfit(collection, currentPrice);
    total += profit;
  }
  return total;
}

class TotalProfit extends StatelessWidget {
  TotalProfit({required portfolio, required prices})
      : totalProfit = reduceTotalProfit(portfolio, prices);

  final double totalProfit;

  @override
  Widget build(BuildContext context) {
    var color = colorForSign(totalProfit);
    return Padding(
      padding: PositionCollectionInsets,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            totalProfit.toStringAsFixed(2),
            style: TextStyle(
              fontFamily: 'KoHo',
              fontSize: 42,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class Portfolio extends StatelessWidget {
  Portfolio(this._portfolio, this._prices);

  final Iterable<PositionCollection> _portfolio;
  final Map<String, int> _prices;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TotalProfit(
          portfolio: _portfolio,
          prices: _prices,
        ),
        ..._portfolio.map((collection) {
          return PositionCollectionDisplay(
            collection: collection,
            currentPrice: _prices[collection.symbol]!.toDouble(),
          );
        }).toList(),
      ],
    );
  }
}
