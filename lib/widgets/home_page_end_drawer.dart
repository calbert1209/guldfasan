import 'package:flutter/material.dart';
import 'package:guldfasan/models/position_operation.dart';
import 'package:guldfasan/pages/add_position_page.dart';
import 'package:guldfasan/widgets/text_styles.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class HomePageEndDrawer extends StatelessWidget {
  const HomePageEndDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final theme = Theme.of(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 140.0,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.brown.shade50,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'options',
                    style: RajdhaniBold(
                      fontSize: 32,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text(
              'add position',
              style: RajdhaniMedium(
                fontSize: 24,
                color: Colors.brown.shade700,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push<PositionOperation>(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPositionPage(),
                ),
              ).then((result) {
                if (result != null) {
                  appState.addPosition(result.position);
                }
              });
            },
          ),
          ListTile(
            enabled: false,
            leading: Icon(Icons.list),
            title: Text(
              'list positions',
              style: RajdhaniMedium(
                fontSize: 24,
                color: Colors.grey.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
