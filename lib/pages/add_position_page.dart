import 'package:flutter/material.dart';
import 'package:guldfasan/widgets/edit_position_form.dart';
import 'package:guldfasan/widgets/sub_page_scaffold.dart';

class AddPositionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SubPageScaffold(
      onCompleted: () => Navigator.pop(context),
      title: "Add Position",
      child: Column(
        children: [
          EditPositionForm(),
        ],
      ),
    );
  }
}
