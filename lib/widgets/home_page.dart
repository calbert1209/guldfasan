import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guldfasan/app_state.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/widgets/position_collection_display.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final Map<String, double> prices = {"BTC": 543219.77, "ETH": 35000.45};
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.rajdhani(
            textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 32),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: appState.portfolio.map((PositionCollection collection) {
            return PositionCollectionDisplay(
              collection: collection,
              currentPrice: prices[collection.symbol]!,
            );
          }).toList(),
        ),
      ),
    );
  }
}
