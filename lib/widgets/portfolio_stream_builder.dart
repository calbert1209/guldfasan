import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/services/fetcher.dart';
import 'package:guldfasan/widgets/portfolio.dart';
import 'package:guldfasan/widgets/text_styles.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

final _formatDate = DateFormat("yyyy-MM-dd HH:mm:ss").format;

class PortfolioStreamBuilder extends StatelessWidget {
  PortfolioStreamBuilder(this._portfolio);

  final Iterable<PositionCollection> _portfolio;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return StreamBuilder<FetchedMessage>(
      stream: appState.stream,
      builder: (BuildContext context, AsyncSnapshot<FetchedMessage> snapshot) {
        Map<String, int>? priceData;
        var timestamp = "fetching prices...";
        if (snapshot.hasError) {
          print(snapshot.error);
        }
        if (snapshot.hasData && snapshot.data != null) {
          if (snapshot.data!.hasPrices()) {
            priceData = snapshot.data!.prices;
          }
          timestamp = _formatDate(DateTime.now());
        }
        return Column(
          children: [
            Portfolio(_portfolio, priceData),
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Text(
                'last updated: $timestamp',
                style: RajdhaniMedium(
                  color: Colors.brown.shade200,
                  fontSize: 12.0,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
