import 'package:flutter/material.dart';
import 'package:guldfasan/models/position_operation.dart';
import 'package:guldfasan/pages/edit_position_subpage.dart';

class AddPositionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EditPositionSubPage(
      title: "Add Position",
      onUpdatedHandler: (position) {
        Navigator.pop(
          context,
          PositionOperation(
            position: position,
            type: OperationType.create,
          ),
        );
      },
    );
  }
}
