import 'package:flutter/material.dart';
import 'package:guldfasan/app_state.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/widgets/portfolio_stream_builder.dart';
import 'package:guldfasan/widgets/text_styles.dart';
import 'package:provider/provider.dart';

import 'home_page_end_drawer.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown.shade50,
        foregroundColor: theme.primaryColor,
        title: Text(
          'Overview',
          style: RajdhaniBold(
            fontSize: 32,
            color: theme.primaryColor,
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: theme.primaryColor,
              ),
            ),
          ),
        ],
      ),
      endDrawerEnableOpenDragGesture: false,
      endDrawer: HomePageEndDrawer(),
      body: ListView(
        padding: EdgeInsets.only(bottom: 80.0),
        children: [
          FutureBuilder(
            future: appState.portfolio,
            builder: (BuildContext context,
                AsyncSnapshot<Iterable<PositionCollection>> snapshot) {
              if (snapshot.hasError) {
                return Text(
                  snapshot.error.toString(),
                );
              } else if (snapshot.hasData) {
                return PortfolioStreamBuilder(snapshot.data!);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.repeat,
          color: Colors.white,
        ),
        backgroundColor: theme.primaryColor,
        onPressed: () {
          appState.triggerImmediateFetch();
        },
      ),
    );
  }
}
