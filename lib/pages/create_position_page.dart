import 'package:flutter/material.dart';
import 'package:guldfasan/widgets/sub_page_scaffold.dart';

class CreatePositionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SubPageScaffold(
      onCompleted: () => Navigator.pop(context),
      title: "Create Position",
      child: Column(
        children: [
          Text("One"),
          Text("Two"),
          Text("Three"),
        ],
      ),
    );
  }
}
