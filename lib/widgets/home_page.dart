import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        title: Text(
          title,
          style: GoogleFonts.rajdhani(
            textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 32),
          ),
        ),
      ),
      body: FutureBuilder(
        future: appState.portfolio(),
        builder: (BuildContext context,
            AsyncSnapshot<Iterable<PositionCollection>> snapshot) {
          if (snapshot.hasError) {
            return Text(
              snapshot.error.toString(),
            );
          } else if (snapshot.hasData) {
            return Portfolio(snapshot.data!);
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
