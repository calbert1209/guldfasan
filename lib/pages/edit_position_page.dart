import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/models/position_operation.dart';
import 'package:guldfasan/pages/edit_position_subpage.dart';

class EditPositionPage extends StatelessWidget {
  EditPositionPage({Key? key, required this.position}) : super(key: key);

  final Position position;
  @override
  Widget build(BuildContext context) {
    return EditPositionSubPage(
      title: "Edit Position",
      position: position,
      onUpdatedHandler: (position) {
        Navigator.pop(
          context,
          PositionOperation(
            position: position,
            type: OperationType.update,
          ),
        );
      },
    );
  }
}
