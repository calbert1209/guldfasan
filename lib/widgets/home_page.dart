import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:guldfasan/app_state.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/widgets/portfolio.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.amber.shade700,
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontWeight: FontWeight.w700,
            fontSize: 32,
            color: Colors.amber.shade700,
          ),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: appState.portfolio(),
            builder: (BuildContext context,
                AsyncSnapshot<Iterable<PositionCollection>> snapshot) {
              if (snapshot.hasError) {
                return Text(
                  snapshot.error.toString(),
                );
              } else if (snapshot.hasData) {
                return PortfolioStreamBuilder(snapshot.data!);
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}

class SillyStreamBuilder extends StatelessWidget {
  SillyStreamBuilder(this.receivePort);

  final ReceivePort receivePort;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
        stream: receivePort,
        builder: (context, snapshot) {
          return Text(snapshot.hasData ? '${snapshot.data}' : '?');
        },
      ),
    );
  }
}
