import 'package:flutter/material.dart';
import 'package:guldfasan/app_state.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/widgets/position_collection_display.dart';
import 'package:provider/provider.dart';

class PortfolioStreamBuilder extends StatelessWidget {
  PortfolioStreamBuilder(this._portfolio);

  final Iterable<PositionCollection> _portfolio;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return StreamBuilder(
      stream: appState.receivePort,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        var priceData = {"BTC": -1, "ETH": -1};
        var timestamp = "not updated!";
        if (snapshot.hasError) {
          print(snapshot.error);
        }
        if (snapshot.hasData) {
          priceData = snapshot.data;
          timestamp = DateTime.now().toIso8601String();
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('last updated: $timestamp'),
            ),
            Portfolio(_portfolio, priceData),
            SillyPushPopExample()
          ],
        );
      },
    );
  }
}

class Portfolio extends StatelessWidget {
  Portfolio(this._portfolio, this._prices);

  final Iterable<PositionCollection> _portfolio;
  final Map<String, int> _prices;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _portfolio.map((collection) {
          return PositionCollectionDisplay(
            collection: collection,
            currentPrice: _prices[collection.symbol]!.toDouble(),
          );
        }).toList(),
      ),
    );
  }
}

// :::: example of Navigator push / pop with results ::::::::::::::::::::::::::

class SillyPushPopExample extends StatelessWidget {
  const SillyPushPopExample({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // A pushed Route can return some value
        // here its a string
        // this value is return as a second arg in
        // Navigator.pop() below
        Navigator.push<String>(
          context,
          MaterialPageRoute(
            builder: (context) => MyContainer(),
          ),
        ).then((someText) => print(someText));
      },
      child: Text("Push Route to Stack"),
    );
  }
}

class MyPage extends StatelessWidget {
  MyPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyContainer(),
    );
  }
}

class MyContainer extends StatelessWidget {
  const MyContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Pop Route from Stack'),
              // the future created by Navigator.push() will resolve with
              // the 2nd arg given to Navigator.pop() here.
              onPressed: () => Navigator.pop(
                context,
                DateTime.now().toIso8601String(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
