import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:guldfasan/services/db.dart';
import 'package:guldfasan/services/fetcher.dart';
import 'package:provider/provider.dart';
import 'package:guldfasan/app_state.dart';
import 'package:guldfasan/widgets/home_page.dart';

final ReceivePort mainReceivePort = new ReceivePort();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Isolate.spawn(fetcher, mainReceivePort.sendPort);
  final dbService = DatabaseService();
  runApp(App(dbService));
}

/*
Rajdhani
32 / 700 / amber700
32 / 700 / default
24 / 700 / default
14 / 700 / default
14 / default / grey

KoHo
42 / 500 / default
40 / 500 / default
32 / default / grey
32 / 300 / default
20 / 300 / grey
 */

Widget buildHomePage(BuildContext context, Widget? _) {
  return HomePage(title: 'Guldfasan');
}

class App extends StatelessWidget {
  App(this._dbService);

  final DatabaseService _dbService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guldfasan',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: ChangeNotifierProvider<AppState>(
        create: (BuildContext context) => AppState(_dbService, mainReceivePort),
        builder: buildHomePage,
      ),
    );
  }
}
