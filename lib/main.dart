import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guldfasan/app_state.dart';
import 'package:guldfasan/widgets/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guldfasan',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: ChangeNotifierProvider<AppState>(
        create: (BuildContext context) => AppState(),
        child: HomePage(title: 'Guldfasan'),
      ),
    );
  }
}
