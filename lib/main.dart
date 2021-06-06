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
        child: HomePage(title: 'Guldfasan'),
      ),
    );
  }
}
