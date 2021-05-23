import 'package:flutter/material.dart';
import 'package:guldfasan/services/db.dart';
import 'package:provider/provider.dart';
import 'package:guldfasan/app_state.dart';
import 'package:guldfasan/widgets/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var dbService = DatabaseService();
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
        primarySwatch: Colors.orange,
      ),
      home: ChangeNotifierProvider<AppState>(
        create: (BuildContext context) => AppState(_dbService),
        child: HomePage(title: 'Guldfasan'),
      ),
    );
  }
}
